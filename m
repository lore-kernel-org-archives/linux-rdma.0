From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 02/12] selinux: Create policydb version for Infiniband
 support
Date: Thu, 30 Jun 2016 20:59:25 +0000
Message-ID: <AM4PR0501MB22579221434714783B0AFC68C4240@AM4PR0501MB2257.eurprd05.prod.outlook.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-3-git-send-email-danielj@mellanox.com>
 <CAGH-KgsOE7Ryjy7a6z8Q0o=0yae2FrUc3Qso-1geygULh18Msw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/30/2016 3:17 PM, Paul Moore wrote:
> On Thu, Jun 23, 2016 at 3:52 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Support for Infiniband requires the addition of two new object contexts,
>> one for infiniband PKeys and another IB End Ports.  Added handlers to read
>> and write the new ocontext types when reading or writing a binary policy
>> representation.
>>
>> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  security/selinux/include/security.h |   3 +-
>>  security/selinux/ss/policydb.c      | 129 +++++++++++++++++++++++++++++++-----
>>  security/selinux/ss/policydb.h      |  27 +++++---
>>  3 files changed, 135 insertions(+), 24 deletions(-)
> ...
>
>> diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
>> index 992a315..78b819c 100644
>> --- a/security/selinux/ss/policydb.c
>> +++ b/security/selinux/ss/policydb.c
>> @@ -2219,6 +2229,58 @@ static int ocontext_read(struct policydb *p, struct policydb_compat_info *info,
>>                                         goto out;
>>                                 break;
>>                         }
>> +                       case OCON_PKEY: {
>> +                               rc = next_entry(nodebuf, fp, sizeof(u32) * 6);
>> +                               if (rc)
>> +                                       goto out;
>> +
>> +                               c->u.pkey.subnet_prefix = be64_to_cpu(*((__be64 *)nodebuf));
>> +                               /* The subnet prefix is stored as an IPv6
>> +                                * address in the policy.
>> +                                *
>> +                                * Check that the lower 2 DWORDS are 0.
>> +                                */
> Any particular reason why you reusing an IPv6 address format here?
> Why not use a u64 for the prefix and u16/u32 fields for the partition
> keys?
The subnet prefix is the high order bytes of an IPv6 address and there is infrastructure in place in the userland utilities that deal with IPv6 addresses (parsing them with a :: to eliminate the need to fill out the 0's for example).

Regarding u16, the policy is packed with everything in u32, as you can see in OCON_NODE6 and OCON_PORT handling.
>> +                               if (nodebuf[2] || nodebuf[3]) {
>> +                                       rc = -EINVAL;
>> +                                       goto out;
>> +                               }
>> +
>> +                               if (nodebuf[4] > 0xffff ||
>> +                                   nodebuf[5] > 0xffff) {
>> +                                       rc = -EINVAL;
>> +                                       goto out;
>> +                               }
>> +
>> +                               c->u.pkey.low_pkey = le32_to_cpu(nodebuf[4]);
>> +                               c->u.pkey.high_pkey = le32_to_cpu(nodebuf[5]);
>> +
>> +                               rc = context_read_and_validate(&c->context[0],
>> +                                                              p,
>> +                                                              fp);
>> +                               if (rc)
>> +                                       goto out;
>> +                               break;
>> +                       }
>> +                       case OCON_IB_END_PORT:
> This is a little bit of bikeshedding, but is there such thing as an IB
> "port" that isn't an *end* "port"?  Could we simply use OCON_IB_PORT?
Jason Gunthorpe requested that the name be end_port  in the RFC series.
>> +                               rc = next_entry(buf, fp, sizeof(u32) * 2);
>> +                               if (rc)
>> +                                       goto out;
>> +                               len = le32_to_cpu(buf[0]);
>> +
>> +                               rc = str_read(&c->u.ib_end_port.dev_name, GFP_KERNEL,
>> +                                             fp,
>> +                                             len);
>> +                               if (rc)
>> +                                       goto out;
>> +
>> +                               c->u.ib_end_port.port = le32_to_cpu(buf[1]);
> No range checking on the port value like you do on the partition keys above?

I can add a similar check.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
