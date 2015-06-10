From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 1/4] IB/netlink: Add defines for local service requests
 through netlink
Date: Wed, 10 Jun 2015 15:54:49 -0400
Message-ID: <55789609.4020906@dev.mellanox.co.il>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com> <1433861837-26177-2-git-send-email-kaike.wan@intel.com> <55787827.7030003@dev.mellanox.co.il> <3F128C9216C9B84BB6ED23EF16290AFB0CABCD80@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CABCD80-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/10/2015 2:31 PM, Wan, Kaike wrote:
>> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>> Sent: Wednesday, June 10, 2015 1:47 PM
>>
>> On 6/9/2015 10:57 AM, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>>> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>
>>> This patch adds netlink defines for SA client, local service group,
>>> local service operations, and related attributes.
>>>
>>> Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> ---
>>>  include/uapi/rdma/rdma_netlink.h |   82
>> ++++++++++++++++++++++++++++++++++++++
>>>  1 files changed, 82 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/include/uapi/rdma/rdma_netlink.h
>>> b/include/uapi/rdma/rdma_netlink.h
>>> index 6e4bb42..341e9be 100644
>>> --- a/include/uapi/rdma/rdma_netlink.h
>>> +++ b/include/uapi/rdma/rdma_netlink.h
>>> @@ -7,12 +7,14 @@ enum {
>>>  	RDMA_NL_RDMA_CM = 1,
>>>  	RDMA_NL_NES,
>>>  	RDMA_NL_C4IW,
>>> +	RDMA_NL_SA,
>>>  	RDMA_NL_NUM_CLIENTS
>>>  };
>>>
>>>  enum {
>>>  	RDMA_NL_GROUP_CM = 1,
>>>  	RDMA_NL_GROUP_IWPM,
>>> +	RDMA_NL_GROUP_LS,
>>>  	RDMA_NL_NUM_GROUPS
>>>  };
>>>
>>> @@ -128,5 +130,85 @@ enum {
>>>  	IWPM_NLA_ERR_MAX
>>>  };
>>>
>>> +/* Local service group opcodes */
>>> +enum {
>>> +	RDMA_NL_LS_OP_RESOLVE = 0,
>>> +	RDMA_NL_LS_OP_SET_TIMEOUT,
>>> +	RDMA_NL_LS_NUM_OPS
>>> +};
>>> +
>>> +/* Local service netlink message flags */
>>> +#define RDMA_NL_LS_F_OK		0x0100	/* Success response */
>>> +#define RDMA_NL_LS_F_ERR	0x0200	/* Failed response */
>>> +
>>> +/* Local service attribute type */
>>> +enum {
>>> +	LS_NLA_TYPE_STATUS = 0,
>>> +	LS_NLA_TYPE_PATH_RECORD,
>>> +	LS_NLA_TYPE_TIMEOUT,
>>> +	LS_NLA_TYPE_SERVICE_ID,
>>> +	LS_NLA_TYPE_DGID,
>>> +	LS_NLA_TYPE_SGID,
>>> +	LS_NLA_TYPE_TCLASS,
>>> +	LS_NLA_TYPE_REVERSIBLE,
>>> +	LS_NLA_TYPE_NUM_PATH,
>>
>> Should this be NUMB_PATH rather than NUM_PATH ?
> 
> Yes. 
> 
>>
>>> +	LS_NLA_TYPE_PKEY,
>>> +	LS_NLA_TYPE_QOS_CLASS,
>>
>> Should this include SL too ?
> 
> It will be another attribute. 

If SL is to be included, maybe it should be SL mask. Maybe this is an
example of future extensibility...

> All the fields are modeled after struct ib_sa_path_rec and struct ib_user_path_rec,  
> not after struct ibv_path_record in the user space. In addition, only those pathrecord components that are currently 
> used by rdma_cm, ipoib, and srp are list here.

Understood.

>>
>>> +	LS_NLA_TYPE_MAX
>>> +};
>>> +
>>> +/* Local service status attribute */
>>> +enum {
>>> +	LS_NLA_STATUS_SUCCESS = 0,
>>> +	LS_NLA_STATUS_EINVAL,
>>> +	LS_NLA_STATUS_ENODATA,
>>> +	LS_NLA_STATUS_MAX
>>> +};
>>> +
>>> +struct rdma_nla_ls_status {
>>> +	__u32		status;
>>> +};
>>> +
>>> +/* Local service pathrecord attribute: struct ib_path_rec_data */
>>> +
>>> +/* Local service timeout attribute */ struct rdma_nla_ls_timeout {
>>> +	__u32		timeout;
>>> +};
>>> +
>>> +/* Local Service ServiceID attribute */ struct rdma_nla_ls_service_id
>>> +{
>>> +	__be64		service_id;
>>> +};
>>> +
>>> +/* Local Service DGID/SGID attribute: big endian */ struct
>>> +rdma_nla_ls_gid {
>>> +	__u8		gid[16];
>>> +};
>>> +
>>> +/* Local Service Traffic Class attribute */ struct rdma_nla_ls_tclass
>>> +{
>>> +	__u8		tclass;
>>> +};
>>> +
>>> +/* Local Service Reversible attribute */ struct
>>> +rdma_nla_ls_reversible {
>>> +	__u32		reversible;
>>> +};
>>
>> Isn't __u8 sufficient for reversible ?
> Certainly enough. However, reversible is __u32 in struct ib_user_path_rec and int in struct ib_sa_path_rec.

OK; I hadn't double checked there. So it's "inherited" from those
reversible definitions.

>>
>>> +
>>> +/* Local Service numb_path attribute */ struct rdma_nla_ls_numb_path
>>> +{
>>> +	__u8		numb_path;
>>> +};
>>> +
>>> +/* Local Service Pkey attribute*/
>>> +struct rdma_nla_ls_pkey {
>>> +	__be16		pkey;
>>> +};
>>> +
>>> +/* Local Service Qos Class attribute */ struct rdma_nla_ls_qos_class
>>> +{
>>> +	__be16		qos_class;
>>> +};
>>>
>>>  #endif /* _UAPI_RDMA_NETLINK_H */
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
