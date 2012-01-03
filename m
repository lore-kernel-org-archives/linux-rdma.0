From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Tue, 3 Jan 2012 19:18:06 +0000
Message-ID: <CAO+b5-pQmG+ohd=G417A1-0DB8bKBpNEKAtEi0swoyfvaye4xA@mail.gmail.com>
References: <1324316340-29223-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324316340-29223-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 19, 2011 at 5:39 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:
> Roland Dreier (2):
> =A0 =A0 =A0IB/mlx4: Fix shutdown crash accessing a non-existent bitma=
p

Hi Roland,

As far as I can see this fix is upstream as commit
4af3ce0de0c12e5c17811eaefad36ab8e146c0fd but is not yet included in
v3.1.7. Shouldn't this patch be sent to stable such that it gets
included in v3.1.x too ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
