From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 05/12] selinux: Implement Infiniband PKey "Access" access
 vector
Date: Fri, 1 Jul 2016 18:21:54 +0000
Message-ID: <DB6PR0501MB2261BC286E974CFE76B1E901C4250@DB6PR0501MB2261.eurprd05.prod.outlook.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-6-git-send-email-danielj@mellanox.com>
 <CAGH-KgtNiMrLVz_fMG22WcpAL3EQq9ike=EYHfxbBa4Sg2-R8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/1/2016 11:29 AM, Paul Moore wrote:
> On Thu, Jun 23, 2016 at 3:52 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Add a type and access vector for PKeys. Implement the qp_pkey_access
>> and mad_agent_pkey_access hooks to check that the caller has
>> permission to access the PKey on the given subnet prefix.  Add an
>> interface to get the PKey SID. Walk the PKey ocontexts to find an entry
>> for the given subnet prefix and pkey.
>>
>> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  include/linux/lsm_audit.h                        |  7 ++++
>>  security/selinux/hooks.c                         | 41 ++++++++++++++++++++++++
>>  security/selinux/include/classmap.h              |  2 ++
>>  security/selinux/include/initial_sid_to_string.h |  1 +
>>  security/selinux/include/security.h              |  2 ++
>>  security/selinux/ss/services.c                   | 41 ++++++++++++++++++++++++
>>  6 files changed, 94 insertions(+)
>>
>> diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
>> index ffb9c9d..8ff7eae 100644
>> --- a/include/linux/lsm_audit.h
>> +++ b/include/linux/lsm_audit.h
>> @@ -45,6 +45,11 @@ struct lsm_ioctlop_audit {
>>         u16 cmd;
>>  };
>>
>> +struct lsm_pkey_audit {
>> +       u64     subnet_prefix;
>> +       u16     pkey;
>> +};
>> +
>>  /* Auxiliary data to use in generating the audit record. */
>>  struct common_audit_data {
>>         char type;
>> @@ -59,6 +64,7 @@ struct common_audit_data {
>>  #define LSM_AUDIT_DATA_INODE   9
>>  #define LSM_AUDIT_DATA_DENTRY  10
>>  #define LSM_AUDIT_DATA_IOCTL_OP        11
>> +#define LSM_AUDIT_DATA_PKEY    12
>>         union   {
>>                 struct path path;
>>                 struct dentry *dentry;
>> @@ -75,6 +81,7 @@ struct common_audit_data {
>>  #endif
>>                 char *kmod_name;
>>                 struct lsm_ioctlop_audit *op;
>> +               struct lsm_pkey_audit *pkey;
>>         } u;
>>         /* this union contains LSM specific data */
>>         union {
> Please correct me if I'm wrong, but I don't recall seeing any code in
> the patchset which actually logs the extra IB information in the audit
> record, did I miss it?
I didn't make any changes to the audit logging.  The messages look like this.
[245259.895597] audit: type=1400 audit(1467392186.710:631): avc:  denied  { access } for  pid=27519 comm="ib_write_bw" scontext=root:sysadm_r:sysadm_t:s0 tcontext=system_u:object_r:staff_allowed_pkey_t:s0 tclass=infiniband_pkey permissive=1

> I wondered about this earlier in the patchset when we were discussing
> the policy format, and I'm still wondering; perhaps you can help me
> understand IB a bit better ...
>
> From what I gather, the partition key is the IB security boundary, not
> the subnet, is that true?  If so, why are we including the subnet with
> the partition key value/label?  I understand the low/high pkey range
> as a way of simplifying the policy, but I don't quite understand the
> point of tying the subnet to the partition key label.  Would you ever
> want to have multiple labels for a single partition key, or should it
> be a single label for the partition key regardless of the subnet?
>
Each subnet can have a different partition configuration and a node can be on multiple subnets.  By specifying the subnet prefix along with the pkey value the user has flexibility to have different policy for different subnets, instead of a global PKey space that would require coordinating the partition configuration across all subnets.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
