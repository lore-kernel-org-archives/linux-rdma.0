From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: RFC: Splitting of the management git tree in Open Fabrics
Date: Tue, 31 Aug 2010 12:51:59 -0700
Message-ID: <20100831125159.98e6d201.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

As I briefly mentioned in an email to Yevgeny regarding libibumad ABI's; I
believe it is time to break up the management git tree.

With GA of OFED 1.5.2 scheduled for Sept 13, I would like to request comments
from the community about the following split after that GA.

On openfabrics.org/git split management.git into the following trees.

openfabrics.org/git/infiniband-diags.git
openfabrics.org/git/libibumad.git
openfabrics.org/git/libibmad.git
openfabrics.org/git/opensm.git
 
Sasha can populate those from the current management tree.  We believe there
are git commands which will do this without losing any history from the git
trees.

Vlad, what changes would you have to make in the OFED build to accommodate
these packages being in separate git trees?

Any other concerns or comments?

Thanks,
Ira

-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
