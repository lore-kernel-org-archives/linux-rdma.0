From: Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libibmad: Add  ib_resolve_noderecord_via  API
Date: Tue, 12 Feb 2013 15:23:19 -0800
Message-ID: <511ACEE7.7000200@oracle.com>
References: <511AA890.8050106@oracle.com> <511AC06B.3030005@dev.mellanox.co.il> <511ACA52.4060104@oracle.com> <511ACDE4.1080006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511ACDE4.1080006-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, HANLIN.QIAN-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, "Jia Shi (E-mail)" <JIA.SHI-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hal,

ib_resolve_guid_via has timeout parameter but when it is getting called from ib_resolve_portid_str_via the value is specified as 0.


int ib_resolve_portid_str_via(ib_portid_t * portid, char *addr_str,
             enum MAD_DEST dest_type, ib_portid_t * sm_id,
             const struct ibmad_port *srcport)
{


   case IB_DEST_GUID:
     if (!(guid = strtoull(addr_str, 0, 0)))
       return -1;

     /* keep guid in portid? */
     return ib_resolve_guid_via(portid, &guid, sm_id, 0, srcport);


Thanks
Sarat


On 2/12/2013 3:19 PM, Hal Rosenstock wrote:
> On 2/12/2013 6:03 PM, Sarat Kakarla wrote:
>> [SK] I wanted to make ib_resolve_noderecord_via look like ib_resolve_portid_str_via API which does not take any timeout parameter.
>>
>>       I can pass '0' instead of MAD_DEF_TIMEOUT_MS, that's what passed as timeout to ib_resolve_guid_via function from  ib_resolve_portid_str_via function.
>>
>
> Are you looking at an older version of libibmad ? The upstream
> ib_resolve_guid_via has timeout as second parameter as do other similar
> calls to ib_resolve_smlid_via.
>
> -- Hal
>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
