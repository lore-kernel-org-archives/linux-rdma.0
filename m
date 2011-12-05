From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re:
 =?windows-1252?q?=5BRFC=5D_=96_Proposal_for_new_process_for?=
 =?windows-1252?q?_OFED_releases?=
Date: Mon, 5 Dec 2011 09:05:46 +0200
Message-ID: <4EDC6D4A.7060407@mellanox.com>
References: <CD250C48050CFB4D95E78C95F2FDDD6E237661EA@MTLDAG01.mtl.com>
	<1828884A29C6694DAF28B7E6B8A8237323FC20F5@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237323FC20F5-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/2/2011 2:04 AM, Hefty, Sean wrote:
>> We propose a new process for the OFED releases starting from next OFED release:
>> - OFED content will be the relevant kernel.org modules and user space released packages
>> - OFED will offer only backports to the distros  (no fixes)
>
> I think this point needs to be clarified

Sean, Yes, I agree, we have to be precise here, the term back-porting 
has to be made clear:

The kernel is a large piece that keeps moving on - its made of many 
smaller pieces/components, but with very sharp and well defined 
dependencies and interactions.  The rdma stack is far from being an 
isolated piece which you can pull from kernel X and plug into kernel Y - 
this applies all over the place in varying extents - e.g from the RDMA 
HW drivers, through the IB core and up to the ULPs.

The latter is the easiest to explain, as Roland once commented, each IB 
ULP driver is a fish and a eel - so SRP/iSER/rNFS/IPoIB are all IB 
fishes working with the IB core services and with the HW through the 
verbs, but the are part from higher-level constructs in the kernel, such 
as being network device (IPoIB), SCSI Low Level drivers (1st two), iscsi 
transport provider (iser) and RPC provider (rNFS).  Now, BACKPORTING 
these stacks (SCSI, iSCSI, RPC/NFS, etc) isn't something that OFA can 
carry, and it would be self-damaging to create notion with end-users 
that OFED does so. I tend to think this is done now for rNFS, and its a 
mistake. Distributions do that, by the way, but its part of their bread 
and butter.

This argument applies also to the core, yes. The core and IPoIB has 
interactions with the networking stack, e.g around route and neighbour 
lookups, and alike.  The networking stack is something that sits deeply 
into the built in part of the kernel and changes every now and then. 
BACKPORTING here would mean to simply remove sets of patches from the 
core and ipoib.

In the HW drivers space, things could be simpler, but I haven't thought 
about it deeply, though.

To be concrete/constructive here, a per IB stack module individual has 
to be assigned for that backporting, which doesn't mean "make IB code 
from kernel X to build under kernel Y" - lets
see if we have people to actually do that.

For example, on the iser space, and for the stack provided by Mellanox 
to customers - I took the approach of iser_backport(X,Y) = ~Y  --- which 
means that if I have to backport the iser code from kernel X into kernel 
Y, I simply use the iser code that comes with Y

I do that since Y has well/tight integrated iscsi stack for which the 
maintainers worked very hard to produce, and I can't re-invent 
backporting that stack.

The tilde in ~Y stands for slight verb changes that could arise from the 
backporting the rest of the IB stack has gone through, from X to Y, so 
if the verb to create CQ has another param in X vs what it had in Y- I 
add it under the ~ umbrella, is that clear?

Or.
