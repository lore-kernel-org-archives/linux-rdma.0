From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ib/cm: Cancel pending LAP message when exiting
 IB_CM_ESTABLISH state
Date: Fri, 4 Mar 2011 20:50:36 +0200
Message-ID: <AANLkTim9YVM6fWgftQc=9hEPJsgfCzko2wPjsxrOiJXN@mail.gmail.com>
References: <AANLkTikD-2VkuLDZBQiBcrY2xovt53DS02Oqx=u8qdJG@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25CC8C57C9@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC8C57C9-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Moni, I don't have a good way to test that this really fixes your problem,
> but it looks like it should.
> I considered merging the cm state and lap states together, but I wasn't
> convinced that that made things any simpler.
>
Sean,
I have a test that can verify the first hunk of the patch
(ib_send_cm_dreq()). I'll probably have results by Monday and I will
send them to you. For the second and third hunks (cm_dreq_handler()
and cm_rej_handler()) I don't have test thats covers them but I'll try
to think of something.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
