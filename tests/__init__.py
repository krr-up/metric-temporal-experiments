"""
Tests utils
"""


class _ClingoRes:
    """
    Test helper to save clingos response
    """

    def __init__(self):
        """
        Creates the helper
        """
        self.models = []

    @property
    def is_sat(self):
        """
        True if SAT
        """
        return self.n_models > 0

    @property
    def is_unsat(self):
        """
        True if UNSAT
        """
        return self.n_models == 0

    @property
    def n_models(self):
        """
        Number of models
        """
        return len(self.models)

    def on_model(self, m):
        """
        Passed on the on_model callback
        """
        model = []
        for sym in m.symbols(shown=True, theory=True):
            model.append(str(sym))
        model.sort()
        self.models.append(set(model))

    def atom_all(self, atoms):
        """
        The atoms must appear in all models
        """
        for model in self.models:
            if not set(atoms).issubset(model):
                return False
        return True

    def atom_some(self, atoms):
        """
        The atoms must appear together in some model
        """
        for model in self.models:
            if set(atoms).issubset(model):
                return True
        return False

    def atom_if(self, atoms_left, atoms_right):
        """
        The atoms right should appear in every model where th atoms left appear
        """
        for model in self.models:
            if not set(atoms_left).issubset(model):
                continue
            if not set(atoms_right).issubset(model):
                return False
        return True

    def __str__(self):
        """
        String representation for print
        """
        s = ""
        s += "RESULT: " + ("SAT" if self.is_sat else "UNSAT")
        s += "  N_MODELS: " + str(self.n_models)
        s += "  MODELS: " + "\n".join([" ".join(m) for m in (self.models)])
        return s
