From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 for-next 4/4] IB/ipoib: Support SendOnlyFullMember MCG
 for SendOnly join
Date: Sun, 8 May 2016 17:01:28 +0300
Message-ID: <CAAk-MO8YWn1HMWHeYBsxtgspGBRENvPh_03aL62=TBJ8fZ6=6Q@mail.gmail.com>
References: <1462448219-24571-1-git-send-email-erezsh@mellanox.com>
	<1462448219-24571-5-git-send-email-erezsh@mellanox.com>
	<alpine.DEB.2.20.1605052124140.1091@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1605052124140.1091-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 6, 2016 at 5:29 AM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, 5 May 2016, Erez Shitrit wrote:
>
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> index 2588931..fc3e50e 100644
>> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> @@ -64,6 +64,9 @@ struct ipoib_mcast_iter {
>>       unsigned int       send_only;
>>  };
>>
>> +/* join state that allows creating mcg with sendonly member request */
>> +#define SENDONLY_FULLMEMBER_JOIN     8
>
> What are the other join states etc? Should all the join states not be
> defined with struct ib_sa_mcmbember_rec in include/rdma/ib_sa.h?

In the current code there is no define/enum for all the types, all the
code that use them (cma.c, multicast.c, ipoib_multicast.c) use a
specific digit ("1" for full-member in most cases)
probably we need to send a new patch (out of that patchset) that will
enum all of them.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
