From: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/12] selinux: Create policydb version for Infiniband support
Date: Thu, 30 Jun 2016 17:37:34 -0400
Message-ID: <CAGH-Kguca78Ma-VJkOz97ixLHrXDgWQxNURre9tVOh+Qb6C1aQ@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-3-git-send-email-danielj@mellanox.com> <CAGH-KgsOE7Ryjy7a6z8Q0o=0yae2FrUc3Qso-1geygULh18Msw@mail.gmail.com>
 <AM4PR0501MB22579221434714783B0AFC68C4240@AM4PR0501MB2257.eurprd05.prod.outlook.com>
 <CAGH-KgsDc5RJ=9pHDFViOsVT08mUTrCPw4wUoXE2BMrDq6G=bA@mail.gmail.com> <AM4PR0501MB2257CB8E6F84835315734487C4240@AM4PR0501MB2257.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM4PR0501MB2257CB8E6F84835315734487C4240-dp/nxUn679hpbkYrVjfdjcDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 30, 2016 at 5:32 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 6/30/2016 4:18 PM, Paul Moore wrote:
>> On Thu, Jun 30, 2016 at 4:59 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>> On 6/30/2016 3:17 PM, Paul Moore wrote:
>>>> On Thu, Jun 23, 2016 at 3:52 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>
>>>>> Support for Infiniband requires the addition of two new object contexts,
>>>>> one for infiniband PKeys and another IB End Ports.  Added handlers to read
>>>>> and write the new ocontext types when reading or writing a binary policy
>>>>> representation.
>>>>>
>>>>> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>> ---
>>>>>  security/selinux/include/security.h |   3 +-
>>>>>  security/selinux/ss/policydb.c      | 129 +++++++++++++++++++++++++++++++-----
>>>>>  security/selinux/ss/policydb.h      |  27 +++++---
>>>>>  3 files changed, 135 insertions(+), 24 deletions(-)

...
                       }
>>>>> +                       case OCON_IB_END_PORT:
>>>> This is a little bit of bikeshedding, but is there such thing as an IB
>>>> "port" that isn't an *end* "port"?  Could we simply use OCON_IB_PORT?
>>> Jason Gunthorpe requested that the name be end_port  in the RFC series.
>> His reasoning?  Is there a IB port concept that isn't an end port?
> The IB spec defines them as such.  I had called them ib_devices previously though so it's possible he would tolerate "port" instead.

Okay, if that is what they are called that's fine with me.  Perhaps
just squash the macro to OCON_IB_ENDPORT or similar; all those
underscores are messing with my mental parser.

-- 
paul moore
security @ redhat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
