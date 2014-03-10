require 'formula'

class RmlMmc < Formula
  homepage 'http://www.ida.liu.se/labs/pelab/rml'
  url 'http://build.openmodelica.org/apt/pool/contrib/rml-mmc_260.orig.tar.gz'
  version '2.6.0'
  sha1 '22acb73e9d5e0a52c853a8cf73cf10d02d749d36'
  #url 'http://build.openmodelica.org/apt/pool/contrib/rml-mmc_271.orig.tar.gz'
  #version '2.7.1'
  #sha1 '2805a46d9c9abae5c7f007b26faf4927b88bd541'


  # Attention, has a self-signed certificate and svn will prompt you, so
  # do not use --HEAD as a dependency or automatic installation (built-bot).
  head 'https://openmodelica.org/svn/MetaModelica/trunk', :using => :svn

  depends_on 'smlnj'

  def patches
    # fixes non-void return value
    # fix undefined inline, see:
      #http://stackoverflow.com/questions/10243018/inline-function-undefined-symbols-error
    DATA
  end

  def install
    ENV.j1
    ENV['SMLNJ_HOME'] = Formula.factory("smlnj").prefix/'SMLNJ_HOME'

    system "./configure --prefix=#{prefix}"
    system "make CPFLAGS=-fno-omit-frame-pointer"
    system "make install"
  end

  def test
    system "#{bin}/rml", "-v"
  end
end

__END__
diff --git a/runtime/debugging/debug.c b/runtime/debugging/debug.c
index 8d855da..da7a950 100644
--- a/runtime/debugging/debug.c
+++ b/runtime/debugging/debug.c
@@ -603,7 +603,7 @@ char* rmldb_get_relation_type()
 		if (strcmp(name, tmpr->name) == 0)
 		{
 			type = tmpr->type_db->type;
-			if (!type) { fprintf(stdout,"()"); return; } 
+			if (!type) { fprintf(stdout,"()"); return ""; } 
 			switch (type->kind)
 			{
 			case RMLDB_eLISTty:  
diff --git a/runtime/common/rml-core.h b/runtime/common/rml-core.h
index 3a21095..f2fee5c 100644
--- a/runtime/common/rml-core.h
+++ b/runtime/common/rml-core.h
@@ -337,7 +337,7 @@ extern rml_sint_t rml_prim_stringeq(void*, rml_uint_t, const char*);
 #ifdef _MSC_VER
 extern void *rml_prim_equal(void*, void*);
 #else
-inline void *rml_prim_equal(void*, void*);
+extern inline void *rml_prim_equal(void*, void*);
 #endif
 extern void  rml_prim_unwind_(void**);
 
diff --git a/runtime/common/value.c b/runtime/common/value.c
index ffc7082..0402d3a 100644
--- a/runtime/common/value.c
+++ b/runtime/common/value.c
@@ -52,7 +52,7 @@ RML_END_LABEL
 #define inline inline
 #endif
 
-inline void *rml_prim_equal(void *p, void *q)
+extern inline void *rml_prim_equal(void *p, void *q)
 {
   tail_recur:
     /* INV: ISIMM(p) <==> ISIMM(q) */
diff --git a/runtime/common/value.c b/runtime/common/value.c
index 0402d3a..4dd9125 100644
--- a/runtime/common/value.c
+++ b/runtime/common/value.c
@@ -105,7 +105,7 @@ extern inline void *rml_prim_equal(void *p, void *q)
 }
 
 
-inline long long unsigned rml_prim_hash(void *p)
+static inline long long unsigned rml_prim_hash(void *p)
 {
   long long unsigned hash = 0;
   void **pp = NULL;
