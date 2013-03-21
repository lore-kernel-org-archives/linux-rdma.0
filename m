From: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Fwd: Re: [PATCH] libibmad: To reserve upper 8 bits of tid used
 by solaris SRIOV driver
Date: Thu, 21 Mar 2013 18:14:47 +0000
Message-ID: <514B4E17.5020703@oracle.com>
References: <20130320223322.GB30100@obsidianresearch.com> <514A3996.601@oracle.com> <514A525F.7030706@oracle.com> <20130321050709.GA20882@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130321050709.GA20882-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pramod Gunjikar <Pramod.Gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ok so I think we are essentially on the same page...

> This is already the case, only the lower 32 bits are available for
> application use, the upper 32 bits are all reserved for the kernel,
This is not an IB spec defined delineation, but an OF one. Perhaps there 
was some
community discussion to architect it this way but it is not documented. 
At the
very least this patch should document this.

So how about modifying the patch such that mad_trid() is something like:

#define GET_IB_USERLAND_TID(tid) (tid & 0x00000000ffffffff)
/*
   * Generate the  64 bit MAD transaction ID. The upper 32 bits are 
reserved for use
   * by the kernel. We clear the upper 32 bits here, but MADs received 
from the kernel
   * may contain kernel specific data in these bits, consequently 
userland TID matching
   * should only be done on the lower 32 bits.
   */
uint64_t mad_trid(void)
{
         static uint64_t trid;
         uint64_t next;

         if (!trid) {
                 srandom((int)time(0) * getpid());
                 trid = random();
         }
         next = ++trid;
         next = GET_IB_USERLAND_TID(next);
         return next;
}

and in _do_madrpc

-uint32_t trid;          /* only low 32 bits */
+uint32_t trid;          /* only low 32 bits - see mad_trid() */

Brendan

On 21/03/2013 05:07, Jason Gunthorpe wrote:
> On Thu, Mar 21, 2013 at 12:20:47AM +0000, brendan doyle wrote:
>
>>> On Wed, Mar 20, 2013 at 03:11:51PM -0700, Ira Weiny wrote:
>>>> Why does this need to be done in user space?  This seems like
>>>> something which should be done in the kernel for all Transaction ID's
>>>> which might be sent to the umad layer.
>> So the reason we "reserved" not set the upper two bytes of TID in
>> the user space is so that libs and/or applications that rely on TID
>> matching won't break. If we changed the TID in the kernel then the
>> response TID returned to the lib/application would not match the
>> request TID.
> This is already the case, only the lower 32 bits are available for
> application use, the upper 32 bits are all reserved for the kernel,
> and you can learn what they are by doing a SMP to the local SMA. IIRC
> some of my stuff captures the upper 32 bits when it gets the first
> reply - but all userspace demux is only done on the low 32 bits
> anyhow.
>
> It is mysterious why umad sends in all 64 bits, but it isn't
> harmful. If you are going to change it then send 32 bits only.
>   
>>> Agreed, if Solaris is going to emulate the Linux umad dev FD it should
>>> be done properly. The kernel overrides some bits and returns the TRID
>>> it actually put on the wire after the MAD is sent.
>> I don't see where the TID sent is returned to the caller of
>> umad_send(), I see that we pass down a MAD over the fd to the kernel
>> that has a full 64bit TID and then I see that the kernel over writes
>> the upper 32 bits, but I don't see how that is communicated back to
>> the sender of the MAD, so if the sender were doing 64 bit TID
>> matching it would not find its MAD, the upper 32bits it set are
>> lost.
> Certainly, the umad API is problematic in many ways :|
>
>> Note in what we propose, in the userland we just reserve the upper
>> byte, it is the kernel that then uses/sets and unsets this upper
>> byte to include a VF id so MADs send on a VF device can get tunneled
>> to the PF and received on a PF can be directed to the correct VF,
>> the upper byte is cleared before handing back to the userland so
>> that it can do 64 bit TID matching and the TID it specified in the
>> request MAD is the same as the one it gets in the response MAD.
> Masking the TID off in messages coming from the kernel to umad is a
> really bad idea, the TID returned to user space should exactly match
> the on-the-wire value. This is why 64 bits are allocated for a 32 bit
> value. Otherwise you have to create ugly special cases for requests vs
> reply vs trap and it precludes userspace producing sensible packet
> traces and the like.
>
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
