From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] checkpatch: Introduce check for format of Fixes line in
 commit log
Date: Thu, 19 Oct 2017 05:52:41 +0000
Message-ID: <VI1PR0502MB3008662D9D9D1BF80461C7CCD1420@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1507675467-24316-1-git-send-email-parav@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507675467-24316-1-git-send-email-parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org" <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, "apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org" <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Erickson <bradley-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Joe,

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Parav Pandit
> Sent: Tuesday, October 10, 2017 5:44 PM
> To: joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org; apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Parav Pandi=
t
> <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Brad Erickson <bradley-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: [PATCH] checkpatch: Introduce check for format of Fixes line in =
commit
> log
>=20
> This patch introduces a format check for 'Fixes' line in commit log for 1=
2
> characters commit id and format for Fixes as ("...").
>=20
> Its created against linux-rdma Doug's tree [1].
>=20
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
>=20
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Brad Erickson <bradley-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  scripts/checkpatch.pl | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl index
> dd2c262..7d933e4 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2548,6 +2548,14 @@ sub process {
>  			      "Remove Gerrit Change-Id's before submitting
> upstream.\n" . $herecurr);
>  		}
>=20
> +# Check for incorrect format for Fixes line in commit log
> +		if ($in_commit_log && $line =3D~ /^\s*Fixes:/i) {
> +			if ($line !~ /^\s*Fixes: [a-z0-9]{12} \(\".*?\"\)$/i) {
> +				ERROR("FIXES_FORMAT",
> +				      "Follow format of Fixes: <12 characters
> commit id> (\"...\")\n" . $herecurr);
> +			}
> +		}
> +
>  # Check if the commit log is in a possible stack dump
>  		if ($in_commit_log && !$commit_log_possible_stack_dump &&
>  		    ($line =3D~ /^\s*(?:WARNING:|BUG:)/ ||
> --

Did you get a chance to review this minor improvement patch?
Does it look ok?
Can it be pushed to Linux-rdma tree?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
