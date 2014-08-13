From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: [PATCH v1 1/1] mlx4: disable TSO for Connect-X rev a0 cards
Date: Wed, 13 Aug 2014 14:07:30 +0000
Message-ID: <8dde8773-7e00-41ae-a38e-33ed38e2ccb4@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-c5c89ad9-b8aa-4426-bcaf-1bc2b91fdca3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-c5c89ad9-b8aa-4426-bcaf-1bc2b91fdca3
Content-Type: text/plain

commit 269a731254c4b8daa22ce09108e239dce7e6bb71
Author: Markus Stockhausen <markus.stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Date:   Sun Aug 10 17:25:55 2014 +0000

    mlx4: disable TSO for Connect-X rev a0 cards

    According to http://marc.info/?t=138347640900004&r=1&w=2 Connect-X
    cards with revision a0 do not correctly assemble TSO packets. So
    simply disable that feature.

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 0f7027e..c6fd057 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -59,6 +59,7 @@
 
 #define MLX4_IB_FLOW_MAX_PRIO 0xFFF
 #define MLX4_IB_FLOW_QPN_MASK 0xFFFFFF
+#define MLX4_IB_CARD_REV_A0   0xA0
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("Mellanox ConnectX HCA InfiniBand driver");
@@ -158,7 +159,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_UD_AV_PORT_ENFORCE;
 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_IPOIB_CSUM)
 		props->device_cap_flags |= IB_DEVICE_UD_IP_CSUM;
-	if (dev->dev->caps.max_gso_sz && dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BLH)
+	if (dev->dev->caps.max_gso_sz &&
+	    (dev->dev->rev_id != MLX4_IB_CARD_REV_A0) &&
+	    (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BLH))
 		props->device_cap_flags |= IB_DEVICE_UD_TSO;
 	if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_RESERVED_LKEY)
 		props->device_cap_flags |= IB_DEVICE_LOCAL_DMA_LKEY;

------=_NextPartTM-000-c5c89ad9-b8aa-4426-bcaf-1bc2b91fdca3
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-c5c89ad9-b8aa-4426-bcaf-1bc2b91fdca3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
