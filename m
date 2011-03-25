From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: RDMA CM: private_data_len
Date: Fri, 25 Mar 2011 19:27:41 +0100
Message-ID: <1301077661.2192.31.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

On a client, rdma_connect() returns -1 and set errno EINVAL if 
struct rdma_conn_param->private_data_len is set to something higher than
56 bytes.

But on a server, using rdma_accept() with struct
rdma_conn_param->private_data_len is set to 64 (for example) didn't
return any error. 

What is the maximum data size that can be exchanged between peers at
connection time, and where to find its definition (at compile time or at
runtime) ?

Regards.

-- 
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
