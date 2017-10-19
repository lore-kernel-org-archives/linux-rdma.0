From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] checkpatch: Introduce check for format of Fixes line in
 commit log
Date: Wed, 18 Oct 2017 22:57:17 -0700
Message-ID: <1508392637.6806.33.camel@perches.com>
References: <1507675467-24316-1-git-send-email-parav@mellanox.com>
         <VI1PR0502MB3008662D9D9D1BF80461C7CCD1420@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008662D9D9D1BF80461C7CCD1420-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org" <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Erickson <bradley-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-10-19 at 05:52 +0000, Parav Pandit wrote:
> Hi Joe,

Hello Parav

> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Parav Pandit
> > Sent: Tuesday, October 10, 2017 5:44 PM
> > To: joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org; apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
> > Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Parav Pandit
> > <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Brad Erickson <bradley-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Subject: [PATCH] checkpatch: Introduce check for format of Fixes line in commit
> > log
> > 
> > This patch introduces a format check for 'Fixes' line in commit log for 12
> > characters commit id and format for Fixes as ("...").

I think this doesn't handle case like:

Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=58735

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
