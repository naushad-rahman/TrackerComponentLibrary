function vec=getPermIndices(rank,n,dim)
%%GETPERMINDICES Get a vector of indices that can be used to rearrange the
%                subvectors in a vector consisting of n subvectors of
%                dimensionality dim according to the permutation of the
%                given rank in lexicographic ordering.
%
%INPUTS:    rank The order of the desired permutation of
%                [0 1 2 ... n-1] in lexicographic order. Note 
%                that 0<=rank<=(n!-1).
%           n    The number of stacked vectors that are to be permuted.
%           dim  The dimensionality of the n subvectors being permutated.
%
%OUTPUTS:   vec  A vector of indices that can be used to reorder the
%                subvectors of a vector of n subvectors of dimensionality
%                dim.
%
%Given an (n*dim)X1 vector v of n stacked subvectors of dimension dim, 
%v(vec) rearranges the subvectors in v according to the given permutation.
%This rearrangement can also be performed in a less computationally
%efficient manner using a permutation matrix generated by the function
%getPermMatrix.
%
%September 2013 David F. Crouse, Naval Research Laboratory, Washington D.C.
%(UNCLASSIFIED) DISTRIBUTION STATEMENT A. Approved for public release.

    perm=unrankPermutation(rank,n);
    vec=zeros(dim*n,1);
    
    for curPerm=1:n
        baseVec=(curPerm-1)*dim;
        basePerm=(perm(curPerm)-1)*dim;
        
        for off=1:dim
           vec(baseVec+off)=basePerm+off; 
        end
    end
end

%LICENSE:
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
%OF RECIPIENT IN THE USE OF THE SOFTWARE.
