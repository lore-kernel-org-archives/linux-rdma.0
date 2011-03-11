From: Bernardo F Costa <bfcta-dXALDUftOVpQFI55V6+gNQ@public.gmane.org>
Subject: ipoib or not ?
Date: Fri, 11 Mar 2011 10:34:33 -0300
Message-ID: <AANLkTin0xce89H2Py66ZbzHatGfE=aw6MM9KdkmQhGdr@mail.gmail.com>
References: <AANLkTim4WVvfhcVFXA3GHsGZzrSiRKC7q5t1ShkbNZsB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim4WVvfhcVFXA3GHsGZzrSiRKC7q5t1ShkbNZsB-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fellows, I'd like to understand better the consequences of using or
not ipoib on an infiniband cluster used for running mpi jobs. Openmpi
can use the openib BTL without any ip configuration at the ib0 device.
Mys infiniband cluster has this configuration at the moment. Is such
configuration recommended ? If so, when it is and when it is not ? I
am wondering if using ipoib woldn't make the environment more
reliable.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
