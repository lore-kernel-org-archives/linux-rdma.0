From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch v2 33/37] add rxe_net.c
Date: Fri, 5 Aug 2011 20:47:49 +0200
Message-ID: <CAO+b5-pk-X7aGgg12ND17OLcqcLU6qyiV+vf22anh9bYsXUUzw@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.765038738@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.765038738-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM, <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:

(resending as plain text)

+static __be64 rxe_mac_to_eui64(struct net_device *ndev)
+{
+    unsigned char *mac_addr = ndev->dev_addr;
+    __be64 eui64;
+    unsigned char *dst = (unsigned char *)&eui64;
+
+    dst[0] = mac_addr[0] ^ 2;
+    dst[1] = mac_addr[1];
+    dst[2] = mac_addr[2];
+    dst[3] = 0xff;
+    dst[4] = 0xfe;
+    dst[5] = mac_addr[3];
+    dst[6] = mac_addr[4];
+    dst[7] = mac_addr[5];
+
+    return eui64;
+}

The above is a standard EUI-48 into EUI-64 translation I assume ?

Also, I haven't found a function that does the opposite translation -
does that mean that there is no GID-to-rxe-device translation in the
ib_rxe driver yet ? I'd like to give ib_srp over ib_rxe a try, but as
far as I can see that won't work yet ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
