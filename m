From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/mad: Return unsupported for MADs as appropriate
Date: Thu, 19 Jan 2012 07:58:09 -0500
Message-ID: <4F181361.4050505@dev.mellanox.co.il>
References: <20120118084255.18560.40844.stgit@kop-dev-sles11-04.qlogic.org> <20120118084311.18560.22509.stgit@kop-dev-sles11-04.qlogic.org> <4F1747F2.3020308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F1747F2.3020308-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/18/2012 5:30 PM, Hal Rosenstock wrote:
> On 1/18/2012 3:43 AM, Swapna Thete wrote:
>> Setup a response with appropriate error status and
>> send it for the MADs that are not supported by a
>> specific class/version.
>> Signed-off-by: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/infiniband/core/mad.c |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
>> index 2fe428b..734d846 100644
>> --- a/drivers/infiniband/core/mad.c
>> +++ b/drivers/infiniband/core/mad.c
>> @@ -1963,6 +1963,16 @@ local:
>>  		 * or via recv_handler in ib_mad_complete_recv()
>>  		 */
>>  		recv = NULL;
>> +	} else {
>> +		memcpy(response, recv, sizeof(*response));
> 
> Isn't this overkill as the bad MAD status precludes looking at the MAD
> data ?
> 
>> +		response->header.recv_wc.wc = &response->header.wc;
>> +		response->header.recv_wc.recv_buf.mad = &response->mad.mad;
>> +		response->header.recv_wc.recv_buf.grh = &response->grh;
>> +		response->mad.mad.mad_hdr.method = IB_MGMT_METHOD_GET_RESP;
>> +		response->mad.mad.mad_hdr.status =
>> +				__be16_to_cpu(IB_MGMT_MAD_STATUS_BAD_VERSION);
> 
> While this is the best status for class not supported, that's not all
> the cases that get to here. Attribute not supported (in a supported
> class) could also occur here for which unsupported method/attribute
> combination is more appropriate as a MAD status. I'm not sure it's worth
> the effort to discern that (as any invalid MAD status is treated the
> same) but I think it could be done if we want to be more precise about
> the error.

The other alternative is to just return method/attribute combination not
supported (STATUS_FIELD[4:2] = 0x3 (MAD status 0xc)) for all this as
Jack and Or have indicated. FWIW that's my preference.

-- Hal

> 
> -- Hal
> 
>> +		agent_send_response(&response->mad.mad, &recv->grh, wc,
>> +			port_priv->device, port_num, qp_info->qp->qp_num);
>>  	}
>>  
>>  out:
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
