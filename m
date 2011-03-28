From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: RDMA CM: private_data_len
Date: Mon, 28 Mar 2011 10:48:18 +0200
Message-ID: <4D904B52.5000004@mellanox.com>
References: <1301077661.2192.31.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301077661.2192.31.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yann Droneaud wrote:
> On a client, rdma_connect() returns -1 and set errno EINVAL if 
> struct rdma_conn_param->private_data_len is set to something higher than
> 56 bytes.
> 
> But on a server, using rdma_accept() with struct
> rdma_conn_param->private_data_len is set to 64 (for example) didn't
> return any error. 
> 
> What is the maximum data size that can be exchanged between peers at
> connection time, and where to find its definition (at compile time or at
> runtime) ?

yep, this isn't clear from the librdmacm man pages see the patch
that follows. BTW - Sean, looking on the code of the library and the
kernel's ucma.c / cma.c - I failed to find where this is enforced,
a pointer will be cool.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
