From: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Fwd: Re: [PATCH] libibmad: To reserve upper 8 bits of tid used
 by solaris SRIOV driver
Date: Thu, 21 Mar 2013 00:20:47 +0000
Message-ID: <514A525F.7030706@oracle.com>
References: <20130320223322.GB30100@obsidianresearch.com> <514A3996.601@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <514A3996.601-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Pramod Gunjikar <Pramod.Gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 20/03/2013 22:35, Boris Chiu wrote:
> fyi,
>
> Boris
>
>
> -------- Original Message --------
> Subject: 	Re: [PATCH] libibmad: To reserve upper 8 bits of tid used by 
> solaris SRIOV driver
> Date: 	Wed, 20 Mar 2013 16:33:22 -0600
> From: 	Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> To: 	Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: 	Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
>
>
> On Wed, Mar 20, 2013 at 03:11:51PM -0700, Ira Weiny wrote:
> > Why does this need to be done in user space?  This seems like
> > something which should be done in the kernel for all Transaction ID's
> > which might be sent to the umad layer.

So the reason we "reserved" not set the upper two bytes of TID in the 
user space
is so that libs and/or applications that rely on TID matching won't 
break. If we
changed the TID in the kernel then the response TID returned to the 
lib/application
would not match the request TID.

Currently the only place I see TID check is in libibmad's _do_madrpc(), 
and here it
effectively does something similar where it truncates the TID to 
32bits.  We send a
MAD with a full 64 bit TID, record the lower 32 bits of the TID, on on 
receipt of the
response check that the lower 32 bits of TID are the same, the upper 32 
could be
completely different.

>
> Agreed, if Solaris is going to emulate the Linux umad dev FD it should
> be done properly. The kernel overrides some bits and returns the TRID
> it actually put on the wire after the MAD is sent.

I don't see where the TID sent is returned to the caller of umad_send(), 
I see
that we pass down a MAD over the fd to the kernel that has a full 64bit 
TID and
then I see that the kernel over writes the upper 32 bits, but I don't 
see how that
is communicated back to the sender of the MAD, so if the sender were doing
64 bit TID matching it would not find its MAD, the upper 32bits it set 
are lost.

Note in what we propose, in the userland we just reserve the upper byte, 
it is the
kernel that then uses/sets and unsets this upper byte to include a VF id so
MADs send on a VF device can get tunneled to the PF and received on a PF 
can be
directed to the correct VF, the upper byte is cleared before handing 
back to the
userland so that it can do 64 bit TID matching and the TID it specified in
the request MAD is the same as the one it gets in the response MAD.

>
> Linux is already doing this to add per-process uniqueness, per-guest
> SRIOV uniqueness should use the same mechanism.

The way it is done in Linux effectively makes the TID a 32bit entity from
the userland perspective.


>
> Thus, this masking is either redundant, or hiding a kernel bug..

I might say it is the other way around. In Linux from the userland the 
TID you get in
a response MAD is not the same as the one you specified in the request MAD.

I'm not debating that the kernel should use upper bits of the TID to demux
per process, per guest, that is what we do in Solaris, what I'm saying
is that those bits used by the kernel should be "reserved"  in userland
so that the TID of its request and response are the same across all 64 bits.

Brendan

> Jason
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
