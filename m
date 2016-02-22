From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH 1/5] IB/isert: Remove ISER_RECV_DATA_SEG_LEN
Date: Mon, 22 Feb 2016 16:55:03 +0200
Message-ID: <CAJ3xEMiGhnsZMdPkqCo25cjdOE8pqZ3A=TfiEvMHsU8Sj3PM8Q@mail.gmail.com>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
	<1456148958-27973-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456148958-27973-2-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 22, 2016 at 3:49 PM, Christoph Hellwig <hch@lst.de> wrote:

> @@ -36,9 +36,7 @@
> -#define ISER_RECV_DATA_SEG_LEN 8192

Sagi,

Can you please explain WW (When & Why) we changed this from 128 bytes
to 8192 bytes?!! do we use 8000++ bytes for every RX descriptor or
this is nowadays only for the login phase? what's the trick?

Or.

> @@ -92,7 +90,7 @@ enum iser_conn_state {
>  struct iser_rx_desc {
>         struct iser_ctrl iser_header;
>         struct iscsi_hdr iscsi_header;
> -       char            data[ISER_RECV_DATA_SEG_LEN];
> +       char            data[ISCSI_DEF_MAX_RECV_SEG_LEN];
>         u64             dma_addr;
>         struct ib_sge   rx_sg;
>         char            pad[ISER_RX_PAD_SIZE];
> --
