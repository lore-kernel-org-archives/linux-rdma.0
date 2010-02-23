From: kovlensky-khu2bkKidpXVItvQsEIGlw@public.gmane.org
Subject: Mellanox firmware on Cisco HCA
Date: 23 Feb 2010 02:20:56 +0100
Message-ID: <20100223012056.775E11D780E@f39.poczta.interia.pl>
Mime-Version: 1.0
Content-Type: TEXT/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi list,

I've got problems with old Cisco HCAs. They are clearly rebranded Mellanox cards running Mellanox firmware, but having PSIDs modified by Cisco. In short - does any document translating Cisco PSIDs to Mellanox PSIDs exist? I'm most vitally interested in the one below. Did anybody manage to guess what Mellanox PSID it really is? I can see multiple candidates in Mellanox firmware table guessing on my own.

Regards,

kovlensky


# tvflash -i
  converting Topspin VSD format
HCA #0: MT25208 Tavor Compat, Lion Cub, revision A0
  Primary image is v4.7.400 build 3.2.0.67, with label 'HCA.LionCub.RevC.A0'
  Secondary image is valid, unknown source

  Vital Product Data
    Product Name: Lion cub
    P/N: SFS-HCA-E2T7-A1
    E/C: Rev: A0
    S/N: CS0637X00120
    Freq/Power: PW=10W;PCIe 8X
    Date Code: 0637
    Checksum: Ok

----------------------------------------------------------------------
Wygraj iPhona >>> http://link.interia.pl/f25d5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
