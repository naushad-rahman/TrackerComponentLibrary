/**MATHGEOMETRICFUNCS  A header file for C++ implementations of 
 *           mathematical functions related to computational geometry. See
 *           the files implementing each function for more details on their
 *           usage.
 *
 *December 2014 David F. Crouse, Naval Research Laboratory, Washington D.C.
 **/
/*(UNCLASSIFIED) DISTRIBUTION STATEMENT A. Approved for public release.*/

#ifndef MATHGEOMETRICFUNCSCPP
#define MATHGEOMETRICFUNCSCPP
#include <stddef.h>
 
bool pointIsInPolygonCPP(const double *P, const size_t numVertices, const double *R, const bool boundaryIsImportant,ptrdiff_t *omega);
void twoLineIntersectionPoint2DCPP(const double *line1, const double *line2,double *point);
double signedPolygonAreaCPP(const double *vertices,const size_t numVertices);
#endif

/*LICENSE:
%
%The source code is in the public domain and not licensed or under
%copyright. The information and software may be used freely by the public.
%As required by 17 U.S.C. 403, third parties producing copyrighted works
%consisting predominantly of the material produced by U.S. government
%agencies must provide notice with such work(s) identifying the U.S.
%Government material incorporated and stating that such material is not
%subject to copyright protection.
%
%Derived works shall not identify themselves in a manner that implies an
%endorsement by or an affiliation with the Naval Research Laboratory.
%
%RECIPIENT BEARS ALL RISK RELATING TO QUALITY AND PERFORMANCE OF THE
%SOFTWARE AND ANY RELATED MATERIALS, AND AGREES TO INDEMNIFY THE NAVAL
%RESEARCH LABORATORY FOR ALL THIRD-PARTY CLAIMS RESULTING FROM THE ACTIONS
%OF RECIPIENT IN THE USE OF THE SOFTWARE.*/
