From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH REPOST FIXES for-3.11 1/4] IB/core: Create QP1 using the
 pkey index which contains the default pkey
Date: Thu, 18 Jul 2013 09:29:43 +0300
Message-ID: <51E78B57.7000303@mellanox.com>
References: <1374070962-328-1-git-send-email-ogerlitz@mellanox.com> <1374070962-328-2-git-send-email-ogerlitz@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373805B82BE@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373805B82BE-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17/07/2013 19:31, Hefty, Sean wrote:
>> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
>> index dc3fd1e..9be6754 100644
>> --- a/drivers/infiniband/core/mad.c
>> +++ b/drivers/infiniband/core/mad.c
>> @@ -2663,6 +2663,7 @@ static int ib_mad_port_start(struct ib_mad_port_private
>> *port_priv)
>>   	int ret, i;
>>   	struct ib_qp_attr *attr;
>>   	struct ib_qp *qp;
>> +	u16 pkey_index = 0;
> This shouldn't need to be initialized, as it is always set further down in the patch.
>
> Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
OK, for V1 will fix && will add your Reviewed-by
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
