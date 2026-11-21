Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795289639;
	b=w3qugjrAC7z6rQiH/7cf+oeuYxQYVp0xsE5ECx7AVHW2Ypz4HYDyPXtdo8Q6L+rGhJnW
	 jnpG9/1VOE5NHICW+GsmYf7Pth6MujN+a8VrkqopXcNgu+1Em8dll86r3UC/+r41AFzV2
	 IlrWFVYxLezInT8r61IJYUBUYxH/ZHbk1ioKANhKb72GvwU7dYQmPZeBIz++Ps54F0pgT
	 T7G9T7kIGYlTmJOxpZIp+Z2bQVy8jtQoDysEFqqd8ytgZYvb7OQ1YsBPOuu1CcrJPJLad
	 aUdUsJduU3oM694WhTbFLZ/l1KH1FCYa4D3IVByEf9BeutbPfGdxAmHqyt5VI6557wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795289639;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qkofz/lYLKL2hpqydjvK6PT32xSgmVVrNto+vh8mHvc=;
	b=ySKYd5KT1d+NyOXaxcq5DwjctiPM7C0T1VIrVLT/w0ls4T3GIb7fSBuhkNd8K818Fyy5
	 24iIdHCmMsFTovhlztmYKaOKQBhCpqCRBUjt+whQFekcby/lES6ASXPgtmwp7FHDmHh5o
	 pOTaaPaaub6ZCt3MXQNgdgRlETmqgqRrfVQYlU73tjAz4i7z4sv2QOWUXZpqMGmt5lwRD
	 di6c3744qyAVjl1NfFD4QUdrUo5JDnhjmwbXDjHHKw6tMqvGB+R5U7Ufr7P+AT82pwkkB
	 zhku/ZQcQvYPbYZd4If0jymlJb0sMf1P7ToHYQw0yxVkMPvQEO/dMWpiar1C4/i9zlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iiitd.ac.in;
	spf=pass smtp.mailfrom=iiitd.ac.in;
	dkim=pass header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=B3NvasS5;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD65606A334
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 19:33:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AD65606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=B3NvasS5
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b3e85baf7cso1189123a91.0
        for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 11:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iiitd.ac.in; s=google; t=1795289638; x=1795894438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qkofz/lYLKL2hpqydjvK6PT32xSgmVVrNto+vh8mHvc=;
        b=B3NvasS5R/IpAlX35qIRffdT3cwwxA+C5KhRyjduvO6OfBM5PoxUFJ34UkMCznsPKs
         +vrKPx8Z0obOdAXYWT4SbfTLGJe+7NSqTR/hbiBns8Q0974IPiWn1HvCs47vQmeAw7BM
         ZQsCXjcTImbsXzOZ+Fx+dPYlnkaFqH7reEVr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795289638; x=1795894438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qkofz/lYLKL2hpqydjvK6PT32xSgmVVrNto+vh8mHvc=;
        b=AxIkr/peACBc+vSEZxOixcIKUX2BK8/Rkv72ZyHpitNO3QasYh6xDubKyTA6kLJ98F
         wKhuUsRT0YgvjjWAi1nH+L6GGy24d43LIBFgzknBtJejc34N6LyyolhU2h042u0vUmim
         gKIfj4dxcyowCXSLsjNqBPpBjFs2HTHiktQ8m/WXHQ9SQYYJJPlxn5qOKUIfFuFOf18M
         n/ZveW3Wh6c7OlAwcQSytnvFQZ2LlEcJ/rH6dDNLmYIqKOiKx63LIao12mho+4f9CoBM
         WOTNA3JGWsVmEOHkSMrsrX2uNx403L9GZyqWxuNLZBievCS2Acvsg5kw/Gyv6VsAzuy/
         gBjg==
X-Forwarded-Encrypted: i=1; AL+hErE01d39nZve+FuKmnidGhPQ+LclOnLaOyuLqMW0AwUkW3dwAGD0qgvzqqd6sd9tTEePC8DJzIBdGYQb@vger.kernel.org
X-Gm-Message-State: APuU4Z+7wN3QG3y5T5jf14gWXT9CtaxVtkRU6AdmwGDut25JreBJjx6x
	ZQhaJZFVpRz1Eq72kD3zdUHek29phyHQMmdzXOA06O3juB42iKt+ZoWqbMZElIFGwHY=
X-Gm-Gg: AZFdTZd/9x+i0+jPatnknDQJmSWbRmaBihrR1/8S/Ua0G+YfaApfVHfJtScqKYNToP3
	0pHvkpzU0aXgZOM+vipg4DOugwnJl099V4qvvZFlOMRZ463FgA9JzgA1X/miLRlWUcji3SJUzm/
	L3Vzf3dlEcsndadGrDvX9c8l6u7HCWfmmlXUsayp9M+fDDO+nLsfISgQXUDUPMPPMJzre6i4lvC
	OYawSt1ZQyAh/eiZcSpFRlDfqrdlEZH5DaqusO0PQFfYIqDVq9xTNZBDStxy+7t99bl2IaLScZD
	Wme3p2wp5+rU8uqgR/cTVGjMO1qU6blfJK8Gkc/Bs5e5vhhO9O43uTLPz4Kwy+IElDN+Xo/3ZBL
	+wge1ZQZqHPiFG6IIoYI1sMC6wLPSnM1S7RzOLjOXEV3a9hDTX0tm40XdIoWfCHClucGiI/srLU
	7jaK/Su7qhPpKloUi9nZIgWusXxDWDUNx2sJBlfUYyJE5sU11goC/vaU4+hwvbBHpQeMxNAdDej
	Sq9DH7tgvDFjaLwLymHM/ox6niXoFqtpvlQjhZwpxRY+6UTD04g3KTGqPMFtJ+2yTBHZGpBCgnz
	zHAkP0zDOjTwiPpYpPPsQykVjPE15moIv6ehyEF/X/gBjsJrXDWkq8Q01apjXxoCu3tVw7oxlb8
	WtwRtQ8n/n/joFpHYGgxIneR2cgOsWclcL6mfulZQ41EUNwK1VSS5erV/ZIohwK+8
X-Received: by 2002:a17:90a:d2c7:b0:3b3:fe22:273d with SMTP id 98e67ed59e1d1-3b41c95b0cdmr6070089a91.41.1795289638560;
        Sat, 21 Nov 2026 11:33:58 -0800 (PST)
Received: from iiitd-S2600STB.iiitd.edu.in ([103.25.231.160])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b217a5bsm2686818a91.0.2026.11.21.11.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 11:33:58 -0800 (PST)
From: Piyus Kedia <piyus@iiitd.ac.in>
To: alibuda@linux.alibaba.com,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	netdev@vger.kernel.org
Cc: Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kapil Vaswani <kapil@presceralabs.ai>,
	Piyus Kedia <piyus@iiitd.ac.in>
Subject: [PATCH net] net/smc: validate the peer's CDC cursors against our own buffers
Date: Sun, 22 Nov 2026 01:03:45 +0530
Message-Id: <20261121193345.2148966-2-piyus@iiitd.ac.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261121193345.2148966-1-piyus@iiitd.ac.in>
References: <20261121193345.2148966-1-piyus@iiitd.ac.in>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A peer's CDC message carries two cursors that are offsets into buffers
described on this side: the producer cursor counts the bytes the peer has
written into the RMB we published to it, and the consumer cursor the bytes
it has taken from the RMB it published to us.  Neither is checked anywhere.

smcr_cdc_msg_to_host() copies both into the connection as they arrive, and
every later user treats them as trustworthy:

 - smc_cdc_msg_recv_action() adds the producer difference to
   conn->bytes_to_rcv under a comment asserting
   "guarantee 0 <= bytes_to_rcv <= rmb_desc->len", which nothing enforces;
 - smc_cdc_handle_urg_data_arrival() reads
   *(base + conn->urg_curs.count - 1), an unbounded index into the RMB;
 - smc_rx_recvmsg() clamps only the first of its two ring chunks
   (rmb_desc->len - cons.count) and uses the remainder unclamped for the
   second, so bytes_to_rcv becomes a copy length.

A peer that reports a cursor larger than the buffer therefore makes the
kernel read past it.  With a 64 KiB RMB and a forged cursor, KASAN on
7.4.0-rc3 reports a 1-byte read in the urgent-data path and a 131072-byte
read in the receive path, the latter via _copy_to_iter() - i.e. the
out-of-bounds bytes are delivered to userspace by recvmsg().

Validate both cursors where the message is accepted, next to the existing
length and sequence-number checks, so that one test covers every consumer.
Each cursor is bounded by the buffer its own arithmetic uses: the producer
cursor by conn->rmb_desc->len as in smc_cdc_msg_recv_action(), the consumer
cursor by conn->peer_rmbe_size as in the diff_cons calculation beside it.
A cursor equal to the buffer length is legitimate (a full ring), so only a
larger one is rejected.  An out-of-range cursor cannot occur in a correct
peer, and the malformed message is dropped like any other.

Signed-off-by: Kapil Vaswani <kapil@presceralabs.ai>
Signed-off-by: Piyus Kedia <piyus@iiitd.ac.in>
---
 net/smc/smc_cdc.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 32d6d03df..03ff10fef 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -466,6 +466,26 @@ void smcd_cdc_rx_init(struct smc_connection *conn)
 
 /***************************** init, exit, misc ******************************/
 
+/* A peer's cursors are offsets into OUR buffers: the producer cursor counts the
+ * bytes it has written into the RMB we gave it, the consumer cursor the bytes it
+ * has taken from the RMB it published to us.  Nothing else checks them.  smcr_cdc_msg_to_host()
+ * copies both into the connection, and from there smc_cdc_msg_recv_action() adds the
+ * producer difference to conn->bytes_to_rcv and the receive path uses that as a
+ * length - so a peer that reports more than the buffer holds makes the kernel read
+ * past it.
+ */
+static bool smcr_cdc_cursors_invalid(struct smc_connection *conn,
+				     struct smc_cdc_msg *cdc)
+{
+	if (!conn->rmb_desc)
+		return true;
+	if (ntohl(cdc->prod.count) > (u32)conn->rmb_desc->len)
+		return true;
+	if (ntohl(cdc->cons.count) > conn->peer_rmbe_size)
+		return true;
+	return false;
+}
+
 static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
 {
 	struct smc_link *link = (struct smc_link *)wc->qp->qp_context;
@@ -499,6 +519,9 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
 			   conn->local_rx_ctrl.seqno))
 		/* received seqno is old */
 		goto out;
+	if (smcr_cdc_cursors_invalid(conn, cdc))
+		/* peer cursor outside the buffer it describes */
+		goto out;
 
 	smc_cdc_msg_recv(smc, cdc);
 out:
