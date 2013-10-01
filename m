From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] An improved infrastructure for uverbs commands (My take
 at designing extensible scheme)
Date: Tue, 01 Oct 2013 15:13:43 +0200
Message-ID: <a8f6521f905732e511576cbc3768f254@meuh.org>
References: <1380039392-15480-1-git-send-email-ydroneaud@opteya.com>
 <524AAAE6.3040508@mellanox.com> <524AB54F.9050205@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <524AB54F.9050205-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 01.10.2013 13:43, Matan Barak a =C3=A9crit=C2=A0:
> On 1/10/2013 1:58 PM, Or Gerlitz wrote:
>> On 24/09/2013 19:16, Yann Droneaud wrote:

>> The patch should be titled as follows
>>=20
>> IB/core:  An improved infrastructure for extending uverbs commands
>>=20
>> Or.
>>=20
>=20
> Really nice work. I also think it's better to move the comp_mask to
> the extended header in order to force future proof.

Yes, that's why in a later patch, not send yet, I've added a 'response=20
header',
so that the "comp_mask" could be returned as part of the infrastructure=
=2E

> In addition, commands that have extensible sub-structures (for
> example, extended address handle in QP attributes in IP based
> addressing patch) should be given as a different UDATA in the cmd
> structure. Therefore, we need a comp_mask in the cmd structure header
> to describe which UDATA structure are included.

You mean a command could be given a variable list or array of UDATA ?
The comp_mask will tell if slots are presents ?

It's quite different from the scheme I proposed where a split is done
so that the provider userspace library (say libmlx4) could add data
to a command independently of data added to the verbs userspace library
(libibverbs).

Having more than 2 parts in a command making the whole thing looking
more like Netlink messages, where a command would be split on multiple=20
"chunks",
each chunks having a unique tag/version.

Processing a command would consist of gathering each known chunk to=20
create a command
for version X, Y, or Z. The command would be be processed
by core/ uverbs and remaining chunks would be given to the hw/ provider=
=2E
[what to do with unprocessed chunks ? ignore or error ?]
Once the command is complete, execution can take place.

This scheme seems more complicated. Is it necessary ?


Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
