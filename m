From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: compile ofed 1.5.3 against lustre kernel
Date: Wed, 15 Jun 2011 16:25:26 -0700
Message-ID: <382A478CAD40FA4FB46605CF81FE39F4F92EC95C@orsmsx507.amr.corp.intel.com>
References: <BANLkTin1Pg3e0S=2Hb3=0W=M_qo_TiqRrw@mail.gmail.com>
 <4DF7C80D.1060408@opengridcomputing.com>
 <alpine.DEB.2.00.1106151610040.4224@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1106151610040.4224-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Christoph wrote, 
>I surely wish this constant nightmare would go away. Could we please have
>OFED trees against each kernel version in use somewhere so that we can
>just do a git pull to get these into the respective trees?

Other people have also asked for this, i.e., a source tree for each kernel
that OFED supports that already has the backports applied, or an install.pl
option that will generate the tree for a given kernel. Perhaps we can
try to get this support in the OFED-1.5.4 release. I will bring it up
For discussion in the OFA EWG that manages the releases. 

Long term it would also be good if these lustre patches were in the upstream
kernel, which would allow them to eventually get into the Linux distros so that
people did not have to be applying patches and building custom kernels. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
