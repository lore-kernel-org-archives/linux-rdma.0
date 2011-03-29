From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma_get_cm_event() vs ibv_async_event()
Date: Tue, 29 Mar 2011 12:45:48 +0200
Message-ID: <4D91B85C.1080106@mellanox.com>
References: <1301052615.2192.15.camel@deela.quest-ce.net>	 <1301059658.2192.23.camel@deela.quest-ce.net>	 <1301391461.2192.41.camel@deela.quest-ce.net>	 <4D91B107.2040007@mellanox.com> <1301394815.2193.2.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301394815.2193.2.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Yann Droneaud wrote:
> So ignoring IBV_EVENT_COMM_EST async event seems the best option when
> using RDMA CM to establish connection ?

no! its a must for the rare case of repeated CM packet loss - Sean,
do you agree to that assertion? should the man page be more clear about 
that?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
