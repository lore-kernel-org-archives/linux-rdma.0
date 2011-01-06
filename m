From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: What is OFED? (vs in-kernel drivers)
Date: Wed, 5 Jan 2011 18:47:43 -0700
Message-ID: <20110106014743.GA2620@obsidianresearch.com>
References: <4D246301.40006@shiftmail.org>
 <20110105191847.GB1211@obsidianresearch.com>
 <4D251C3A.8040701@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D251C3A.8040701-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 06, 2011 at 02:34:50AM +0100, Jabe wrote:

> How wonderful!!
> I would never have hoped in such a reply, you even gave me the
> scripts to compile OFED under Ubuntu automatically!!
> THANKS A LOT !!!

To re-iterate, this doesn't compile OFED - it compiles the upstream
userspace components of open fabrics. OFED takes these components,
modifies them and then packages them. Doing it this way means they are
compatible with the upstream kernel, so you don't need to do anything
except install ubuntu and modprobe

ib_uverbs
ib_umad
ib_ucm
rdma_ucm
ib_ipoib
mlx4_ib

(stick in /etc/modules)

The quibble about OFED vs OFA really only matters if you care about
IBoE, XRC, or a few other vendor-specific things that are not
upstream.

> Only one more question: did I understand correctly that you suggest
> me to use the in-kernel modules on Ubuntu or vanilla kernels, even
> if I compiled OFED for userspace?

Yes, you can do this if you compile OFA upstream sources, not
OFED. OFED userspace is still incompatible with upstream kernels.

Oh, you may also need to put this in /etc/udev/rules.d/20-rdma.rules

# Infiniband devices
KERNEL=="umad[0-9]*",                   NAME="infiniband/%k", GROUP="rdma", MODE="0660"
KERNEL=="issm[0-9]*",                   NAME="infiniband/%k", GROUP="rdma", MODE="0660"
KERNEL=="uverbs[0-9]*",                 NAME="infiniband/%k", GROUP="rdma", MODE="0660"
KERNEL=="ucm[0-9]*",                    NAME="infiniband/%k", GROUP="rdma", MODE="0660"
KERNEL=="rdma_cm",                      NAME="infiniband/%k", GROUP="rdma", MODE="0660"

Since nobody has figured out how to get that upstream...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
