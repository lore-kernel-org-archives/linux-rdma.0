From: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all ports
 of HCA are connected]
Date: Thu, 21 Mar 2013 01:01:59 +0000
Message-ID: <514A5C07.3080308@oracle.com>
References: <5140E1A3.9070706@oracle.com> <51427819.7000505@oracle.com> <514278CA.8010809@oracle.com> <2807E5FD2F6FDA4886F6618EAC48510EBB3F62@CRSMSX102.amr.corp.intel.com> <514A0156.2070009@oracle.com> <20130320190208.GA23478@obsidianresearch.com> <2807E5FD2F6FDA4886F6618EAC48510EBB4214@CRSMSX102.amr.corp.intel.com> <514A3169.7000501@oracle.com> <20130320222422.GA30100@obsidianresearch.com> <514A3BDF.2090105@oracle.com> <20130320231923.GA32300@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130320231923.GA32300-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 20/03/2013 23:19, Jason Gunthorpe wrote:
> On Wed, Mar 20, 2013 at 10:44:47PM +0000, brendan doyle wrote:
>
>> Where is the inconsistency?
> There is no other case in other IB libraries or libibmad itself where
> errno is expected to be set by an int returning function. int
> returning functions should return +ERRNO.

And that is what this patch does, currently we have:

# grep errno *
register.c:#include <errno.h>
rpc.c:#include <errno.h>
rpc.c:          errno = EINVAL;
rpc.c:          errno = ENODEV;
rpc.c:          errno = ENOMEM;
rpc.c:          if (!errno)
rpc.c:                  errno = EIO;
rpc.c:                  if (!errno)
rpc.c:                          errno = EINVAL;

The patch adds:

resolve.c:              if (!errno)
resolve.c:                      errno = EIO;
resolve.c:              if (!errno)
resolve.c:                      errno = EIO;
resolve.c:              if (!errno)
resolve.c:                      errno = EIO;

So where is the inconsistency? what is resolve.c doing that is different 
to what
rpc.c is doing?

>
>> errno is still undefined, it is set in some parts of libibmad and
>> not others, so nothing has changed from a consumer perspective?
> Consistency would be returning +ERRNO from int functions and properly
> propogating return codes from lower layers:
>
>         if (smp_query_via(portinfo, &self, IB_ATTR_PORT_INFO, 0, 0,
>               srcport))
>              return errno;
>
> Would be a better modification.
The patch only sets errno, if it is not set, so if lower layers set it then
it is propagated up.


>
>> +               if (!errno)
>> +                       errno = EIO;
> This is funny, it is not portable to expect that errno will ever be !=
> 0.

Well we have several examples of this exact code segment already in 
libibmad, and
I hazard to say elsewhere in the OFED pkgs. Why is it not portable to 
expect that
errno, *may* not be set on a failure?


>> @@ -178,6 +178,7 @@ int _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int
>>                  status = umad_status(rcvbuf);
>> +               errno = status;
> _do_madrpc already returns int, so this is not great either.

OK I could concede on this, the Solaris kernel uses ib_user_mad_hdr.status
to return an errno to indicate the nature of failure, where as linux does
not.

>> @@ -56,6 +57,7 @@ uint8_t *sa_rpc_call(const struct ibmad_port *ibmad_port,
>> void *rcvbuf,
>>
>>          if (portid->lid <= 0) {
>>                  IBWARN("only lid routes are supported");
>> +               errno = EIO;
>>                  return NULL;
> This one is OK.
>
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
