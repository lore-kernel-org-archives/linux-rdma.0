From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next] IB/core: Don't resolve passive side RoCE L2
 address in cma req handler
Date: Wed, 26 Mar 2014 20:30:51 +0200
Message-ID: <CAJZOPZJwkJmMnOg9MdLgFAdEtSywQBAPVDmyXB4OYz63O7BSWg@mail.gmail.com>
References: <1395851011-8081-1-git-send-email-ogerlitz@mellanox.com>
	<1395853824.3297.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395853824.3297.34.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 26, 2014 at 7:10 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:

> Is that a revert of some patch ?

Its not a full revents,  but I will pick what you are probably
suggesting and mention
in the V1 change-log which commit this  fixes, thanks

> Just add Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I know that but preferns to send the patch myself to the stable mailing list
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
