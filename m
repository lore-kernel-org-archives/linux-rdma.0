From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Tue, 30 Aug 2016 18:02:44 +0300
Message-ID: <CAJ3xEMh=DLafFGu4WCBDMidWUOaEPjsWN_kBE2ofU1GrhDoVxg@mail.gmail.com>
References: <1469800416-125043-1-git-send-email-danielj@mellanox.com>
 <CAHC9VhS1Tg3qr2Nncd_eq_eUXrf-wMickoeoF978Q7L+gN7J1g@mail.gmail.com>
 <VI1PR0501MB24297FF784A085DC0AAE2C1EC4E10@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <CAHC9VhTEOvZ76dNJp35WEhr+r84eZZ6_ZmuaznGLakzZGcXhUw@mail.gmail.com> <20160830074607.GN594@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160830074607.GN594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 30, 2016 at 10:46 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Aug 29, 2016 at 08:00:32PM -0400, Paul Moore wrote:
>> On Mon, Aug 29, 2016 at 5:48 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> w=
rote:
>> > On 8/29/2016 4:40 PM, Paul Moore wrote:
>> >> On Fri, Jul 29, 2016 at 9:53 AM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> w=
rote:
>> >>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >> ...
>> >>
>> >>> Daniel Jurgens (9):
>> >>>   IB/core: IB cache enhancements to support Infiniband security
>> >>>   IB/core: Enforce PKey security on QPs
>> >>>   selinux lsm IB/core: Implement LSM notification system
>> >>>   IB/core: Enforce security on management datagrams
>> >>>   selinux: Create policydb version for Infiniband support
>> >>>   selinux: Allocate and free infiniband security hooks
>> >>>   selinux: Implement Infiniband PKey "Access" access vector
>> >>>   selinux: Add IB Port SMP access vector
>> >>>   selinux: Add a cache for quicker retreival of PKey SIDs
>> >> Hi Daniel,
>> >>
>> >> My apologies for such a long delay in responding to this latest
>> >> patchset; conferences, travel, and vacation have made for a very busy
>> >> August.  After you posted the v2 patchset we had an off-list
>> >> discussion regarding testing the SELinux/IB integration; unfortunatel=
y
>> >> we realized that IB hardware would be needed to test this (no IB
>> >> loopback device), but we agreed that having tests would be beneficial=
.
>> >>
>> >> Have you done any work yet towards adding SELinux/IB tests to the
>> >> selinux-testsuite project?
>> >>
>> >> * https://github.com/SELinuxProject/selinux-testsuite
>> >
>> > Hi Paul, I've not started doing that yet.  I've been waiting for feedb=
ack of any kind from the RDMA list.  I thought the test updates would be mo=
re appropriate around the time I'm submitting the changes to the user space=
 utilities to allow labeling the new types.

>> Okay, no problem.  I just want the tests in place and functional when
>> we merge the kernel code.

> Hi Paul,
> IMHO, you can use Soft RoCE (RXE) [1] for it.

If I got it right, little if not nothing of this patch set is
applicable to RoCE ports, this is about IB ports, Daniel, can you
comment?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
