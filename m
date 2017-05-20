From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v7 0/9] SELinux support for Infiniband RDMA
Date: Sat, 20 May 2017 00:10:10 +0000
Message-ID: <DB5PR05MB16719C4FAB679BAF0BD001C7C4FA0@DB5PR05MB1671.eurprd05.prod.outlook.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
 <VI1PR05MB1678F822760B7C5F8E263573C4E50@VI1PR05MB1678.eurprd05.prod.outlook.com>
 <CAHC9VhQtw4fFrCdKcznHrLDkAJVDhi=y9dYMxtOP23XVKq+rCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/19/2017 2:35 PM, Paul Moore wrote:=0A=
> On Fri, May 19, 2017 at 12:47 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> w=
rote:=0A=
>> On 5/19/2017 7:49 AM, Dan Jurgens wrote:=0A=
>>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>=0A=
>>>=0A=
>>> Note on v7, it applies cleanly on Paul Moores' tree.  'git am' fails to=
=0A=
>>> apply patch 0002* to Dougs' tree, but 'patch' applies it without reject=
s.=0A=
>>> There's a new file that needs to be added before resolving the git am,=
=0A=
>>> drivers/infiniband/core/security.c=0A=
>> There's actually a trivial merge conflict in drivers/infiniband/core/uve=
rbs.c that doesn't cause patch to create a reject file, in the function cre=
ate_qp a my patch adds a "goto err_destroy;".  In Dougs' tree it needs to b=
e changed to "goto err_cb".=0A=
> Thanks for the rebase Daniel.  Aside from the small problems with LSM=0A=
> hook init code that I already mentioned it looks good to me.=0A=
>=0A=
> Considering that we got an ACK from the IB folks on v6 of your=0A=
> patchset I went ahead and merged it into the selinux/next tree.  I do=0A=
> reserve the right to yank it out before the next merge window if we=0A=
> discover any problems with the userspace, policy, or tests, but I=0A=
> think those are moving along nicely at the moment.=0A=
>=0A=
> Doug, and other IB folks, can I get an explicit ACK on this rebased=0A=
> patchset from Daniel?  I don't like sending cross-subsystem changes=0A=
> this large upstream without the associated ACKs.=0A=
=0A=
Thank you, Paul. Understood on the userspace, policy, and tests.  I think t=
he userspace is nearly ready.  I have one pending comment from Stephen that=
 I'll address early next week.  I had a question for Chris PeBenito on some=
 of his comments on the refpolicy patches, so I'm waiting to hear back from=
 him. I've not received any comments on the tests yet.=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
