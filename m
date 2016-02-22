From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] IB/isert: Remove ISER_RECV_DATA_SEG_LEN
Date: Mon, 22 Feb 2016 16:05:58 +0100
Message-ID: <20160222150558.GA29553@lst.de>
References: <1456148958-27973-1-git-send-email-hch@lst.de> <1456148958-27973-2-git-send-email-hch@lst.de> <CAJ3xEMiGhnsZMdPkqCo25cjdOE8pqZ3A=TfiEvMHsU8Sj3PM8Q@mail.gmail.com> <CAJ3xEMgN+j=_zaUfqYQ1yQzUG3fXnKgnJLWU17AeP-51WRcrNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgN+j=_zaUfqYQ1yQzUG3fXnKgnJLWU17AeP-51WRcrNw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Sagi Grimberg <sagig@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 22, 2016 at 04:57:50PM +0200, Or Gerlitz wrote:
> >> @@ -92,7 +90,7 @@ enum iser_conn_state {
> >>  struct iser_rx_desc {
> >>         struct iser_ctrl iser_header;
> >>         struct iscsi_hdr iscsi_header;
> >> -       char            data[ISER_RECV_DATA_SEG_LEN];
> >> +       char            data[ISCSI_DEF_MAX_RECV_SEG_LEN];
> >>         u64             dma_addr;
> >>         struct ib_sge   rx_sg;
> >>         char            pad[ISER_RX_PAD_SIZE];
> 
> BTW that pad is probably just c&p from the initiator, has nothing to do here

The way the RX descriptors work is rather odd in many ways. It's on
my todo list to investigate and rework them.
