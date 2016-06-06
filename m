From: hch <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 2/2] IB/core: Align casting method of
 ib_device_cap_flags enumerations to ULL
Date: Mon, 6 Jun 2016 10:22:46 -0700
Message-ID: <20160606172246.GB21118@infradead.org>
References: <1465230880-25953-1-git-send-email-maxg@mellanox.com>
 <1465230880-25953-3-git-send-email-maxg@mellanox.com>
 <20160606170413.GB28622@infradead.org>
 <CALq1K=JWPk6nPjTV0z1HwfmtnO77Nkyaqx-JTB=8JwH0UtorDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALq1K=JWPk6nPjTV0z1HwfmtnO77Nkyaqx-JTB=8JwH0UtorDA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: hch <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Later on, we will wrap all these shifts in BIT() macros as Greg suggested.

Big NAK to any use of that macro.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
