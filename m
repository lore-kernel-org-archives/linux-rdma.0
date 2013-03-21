From: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all ports
 of HCA are connected]
Date: Thu, 21 Mar 2013 20:37:08 +0000
Message-ID: <514B6F74.9020707@oracle.com>
References: <514278CA.8010809@oracle.com> <2807E5FD2F6FDA4886F6618EAC48510EBB3F62@CRSMSX102.amr.corp.intel.com> <514A0156.2070009@oracle.com> <20130320190208.GA23478@obsidianresearch.com> <2807E5FD2F6FDA4886F6618EAC48510EBB4214@CRSMSX102.amr.corp.intel.com> <514A3169.7000501@oracle.com> <20130320222422.GA30100@obsidianresearch.com> <514A3BDF.2090105@oracle.com> <20130320231923.GA32300@obsidianresearch.com> <514A5C07.3080308@oracle.com> <20130321052122.GB20882@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130321052122.GB20882-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 21/03/2013 05:21, Jason Gunthorpe wrote:
> On Thu, Mar 21, 2013 at 01:01:59AM +0000, brendan doyle wrote:
>> On 20/03/2013 23:19, Jason Gunthorpe wrote:
>>> On Wed, Mar 20, 2013 at 10:44:47PM +0000, brendan doyle wrote:
>>>
>>>> Where is the inconsistency?
>>> There is no other case in other IB libraries or libibmad itself where
>>> errno is expected to be set by an int returning function. int
>>> returning functions should return +ERRNO.
>> And that is what this patch does, currently we have:
>>
>> # grep errno *
>> register.c:#include <errno.h>
>> rpc.c:#include <errno.h>
>> rpc.c:          errno = EINVAL;
>> rpc.c:          errno = ENODEV;
>> rpc.c:          errno = ENOMEM;
>> rpc.c:          if (!errno)
>> rpc.c:                  errno = EIO;
>> rpc.c:                  if (!errno)
>> rpc.c:                          errno = EINVAL;
> I looked at all of these, they are OK because the functions do not
> return int, they are returning pointers.
>
> The 'new' POSIX convention is:
>   - int function returns are 0 on success, -1 on 'not-an-errno' and
>     +ERRNO to indicate error.
>   - 'fd in an int' function returns are -1 on failure with errno set,
>     everything else is a valid fd. (Code that checks for fd's < 0 is
>     pedantically wrong)
>   - pointer function returns are NULL on failure with errno set.
>   - void returns can never fail
>
> The 'old' POSIX convention had int functions return 0 on success and
> set errno. Some function will restrict error returns to -1, others
> leave it open.
OK so then the inconsistency is further down the stack..

int ib_resolve_smlid_via()
        -> uint8_t *smp_query_via()
            -> void *mad_rpc()
                -> int mad_build_pkt()
                  -> void *mad_encode() <- return NULL on fail but does 
not set errno
             -> static int _do_madrpc()
                -> umad_send()
                -> umad_recv)

So if ib_resolve_smlid_via() is to conform to POSIX

This:

   if (!smp_query_via(portinfo, &self, IB_ATTR_PORT_INFO, 0, 0, srcport))
           return -1;

Should be:

  if (!smp_query_via(portinfo, &self, IB_ATTR_PORT_INFO, 0, 0, srcport)) {
          return (errno);
  }

But mad_encode() does not set errno, and also retuning +errno instead of 
-1 would
break the existing API usage.

It seems to me that there are many places in libibmad and libibumad that 
are not
poisx compliant, and the libs could do with an overhaul in this regard, 
however
that would likely break many of the library consumers. So from a 
pragmatic stand
point the proposal was to not break the easting API and cause consumers
to fail, but also to add the ability to distinguish between types of 
failures for a specific
failure mode. And this was just one aspect of the patch the other was to 
harden the
library.


>>>> +               if (!errno)
>>>> +                       errno = EIO;
>>> This is funny, it is not portable to expect that errno will ever be !=
>>> 0.
>> Well we have several examples of this exact code segment already in
>> libibmad, and I hazard to say elsewhere in the OFED pkgs. Why is it
>> not portable to expect that errno, *may* not be set on a failure?
> Copying broken code from elsewhere doesn't make it any more right..

Absolutely agree, and was not suggesting that, but was merely saying 
that we
should have consistency.

> The specs say functions set errno on error return. They say nothing
> about clearing it on success return. Assuming errno is ever 0 is
> absolutely not portable, and IIRC, doesn't work on Linux anyhow.

Humm, again, take a look at umad, it sets errno to 0 before calling the
write() system call. If we are to enforce strict posix lets do it 
everywhere,
but that then would likely break many consumers of the libs.

> To be more specific, if a function doesn't explicitly set errno, then
> the value is simply whatever was left in errno before, ie the errno
> from the last failed system call. The only time it will be 0 is
> immediately after program start, assuming no failed system calls were
> made by the runtime. The first failed system call will set it to a
> value and it will never be 0'd by anything after that.

See above.

>
>>>> @@ -178,6 +178,7 @@ int _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int
>>>>                  status = umad_status(rcvbuf);
>>>> +               errno = status;
>>> _do_madrpc already returns int, so this is not great either.
>> OK I could concede on this, the Solaris kernel uses ib_user_mad_hdr.status
>> to return an errno to indicate the nature of failure, where as linux does
>> not.
> Hrm? Linux will return at least ETIMEDOUT in the .status field.

Well Linux is not my bag, but I couldn't see where in the code this was 
the case.

> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
