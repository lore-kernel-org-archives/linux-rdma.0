From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] An improved infrastructure for uverbs commands (My take
 at designing extensible scheme)
Date: Tue, 01 Oct 2013 14:54:20 +0200
Message-ID: <bcaf46a61582cb83547b0cc1ee5edfb4@meuh.org>
References: <1380039392-15480-1-git-send-email-ydroneaud@opteya.com>
 <524AAAE6.3040508@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <524AAAE6.3040508-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 01.10.2013 12:58, Or Gerlitz a =C3=A9crit=C2=A0:
> On 24/09/2013 19:16, Yann Droneaud wrote:
>> PS: I haven't tested the create_flow() commands, (hopefully)
>> there's no libibverbs support yet for the new commands for the momen=
t.
>> I will try to provide patches to improve create_flow()/destroy_flow(=
)
>> and the way its data structures are expressed.

> Yan, nice doing!

Thanks.

> I am not sure to follow your last comment, this patch do touch
> ib_uverbs_create_flow and ib_uverbs_destroy_flow, what else remains t=
o=20
> do there?
>=20

I have some propositions to try to improve the way flow data structure
are declared (and used). I hope to find time during "Open World=20
=46orum"[1]
to clean-up my patchset in order to send it before the end of v3.12=20
cycle.

> Also, to help acceptance of the patch, could you please re-send it
> with removing all
> the references to emails and the hemisphere summer comment into the
> section below the
> "---"  line at the end of the git formatted patch header? they are al=
l
> irrelevant for long term
> git logging and "git am" will take them off when Roland applies  the=20
> patch.
>=20

It was thought to be a RFC ... but loose the [PATCH RFC] tag while=20
playing
with git am/git format-patch to check the patch.

I feel it was important to record somewhere the history of the patch,
just to be able to search for comments.

I think the current extensible scheme was included too early
despite being proposed for review during many months:
it's currently not needed asis.

I'm sorry to not have enough time to provide some more reviewer=20
bandwidth,
and not being able to provide my reviews on time.

But once started, I had to look back in the patch history to look for
other reviews/comments to understand how this patch was included.

> Matan from Mellanox is reviewing the patch and will send ack or
> comments later today.
>=20

Thanks a lot. But don't take too much time on this version.

I've made more changes on the patch and hope to make it a proper=20
patchset.
I've stalled working on it after the end of "Kernel Recipes" [2],=20
waiting to find
time to look at libibverbs support for the extended commands: in=20
particular
how is split response between core/hw (eg. libibverbs/provider).

The proposed change will include a header for the response to include,
for all extended command, the "comp_mask" and the size of the response
from core/  and from hw/ (eg. provider).

> The patch should be titled as follows
>=20
> IB/core:  An improved infrastructure for extending uverbs commands
>=20

OK.

PS: You might have understood I have little time to work on this=20
features,
     mostly doing this work during conferences ;)

[1] http://www.openworldforum.org/en/
[2] https://kernel-recipes.org/en/


Regards

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
