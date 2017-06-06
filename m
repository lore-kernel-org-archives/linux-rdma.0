From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 6 Jun 2017 13:17:41 -0500
Message-ID: <20170606181741.GA3628@ctung-MOBL3.amr.corp.intel.com>
References: <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
 <1496261429.2608.15.camel@sandisk.com>
 <20170602162849.GA28660@ssaleem-MOBL4.amr.corp.intel.com>
 <20170604053635.GD6868@mtr-leonro.local>
 <20170605022313.GB18172@ctung-MOBL3.amr.corp.intel.com>
 <20170605040030.GG6868@mtr-leonro.local>
 <20170605042007.GA19068@ctung-MOBL3.amr.corp.intel.com>
 <20170605045043.GA17148@ctung-MOBL3.amr.corp.intel.com>
 <20170605060318.GH6868@mtr-leonro.local>
 <1496675296.7171.179.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496675296.7171.179.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 05, 2017 at 11:08:16AM -0400, Doug Ledford wrote:
> On Mon, 2017-06-05 at 09:03 +0300, Leon Romanovsky wrote:
> > On Sun, Jun 04, 2017 at 11:50:43PM -0500, Chien Tin Tung wrote:
> Leon is not a native english speaker, as I assume you aren't.  I would
> suggest that it might be more about failure to understand each other
> and failure to get at the root of the issue than anything that would
> legitimately do damage to anyone's credibility.  You might wish to calm
> down and read my posts in this thread.  I hope I was able to clarify
> things a bit.

Alright, this is my attempt at world peace.

I started with a long email but decided to keep it short.  Please
ask for details if you have questions and remember to keep an open mind.

Here are some links for those interested in understanding the background
leading to this thread:

* Tatyana Nikolova's original commit 30dc5e63d6a5 which introduced
ibnl_unicast()
* Leon's comment to Mustafa's original proposal -
https://patchwork.kernel.org/patch/9235137/
* Mustafa Ismail's accepted patch, cea05eadded0d, to ibnl_unicast()

Netlink is fundamentally sockets.  You can substitute the word socket
for Netlink when you try to get a sense of Netlink functionality.  In
the RDMA subsystem, we use Netlink to communicate between user-space
and kernel.

Current controversy surrounds ibnl_unicast().  It is used to send NL
message from the kernel to the user and the NL flow can be triggered
from both user-space and kernel code.

ibnl_unicast() uses netlink_unicast with the following signature:

int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
                    u32 portid, int nonblock)

The last parameter, nonblock, is important.  It allows the caller to
control the call to wait and retry on failure, provided a timeout value
is set, or not block even with a timeout value set.  The actual mechanism
is very elegant and can be used to solve the issue at hand.

Let me go back to the problem Mustafa tried to solve.  Specifically it 
is an issue with the call to iwpm_add_mapping() failing.  That function
sends a NL message from the kernel to user-space portmapper daemon
using the kernel NL socket.  Mustafa originally proposed to
have two ibnl_unicast functions, one blocking and the other
one non-blocking.  It was shot down by Leon.  In hindsight, we should of
pushed ahead and implemented those two functions.  The blocking function
for iwpm_add_mapping() and the non-blocking function for any NL
interaction from user-space.  This solution can still be implemented
solving everyone's problem and bring world peace. :-)

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
