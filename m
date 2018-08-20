From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] avoid race condition between start_xmit and
 cm_rep_handler
Date: Mon, 20 Aug 2018 10:28:00 -0600
Message-ID: <20180820162800.GA25543@ziepe.ca>
References: <1534541486-16263-1-git-send-email-aaron.s.knister@nasa.gov>
 <CAAk-MO97rinpQXhyy7VZA6HWNwm94UuWAFnLFOSb4mj1wW4fQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAk-MO97rinpQXhyy7VZA6HWNwm94UuWAFnLFOSb4mj1wW4fQw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Erez Shitrit <erezsh@dev.mellanox.co.il>
Cc: Aaron Knister <aaron.s.knister@nasa.gov>, RDMA mailing list <linux-rdma@vger.kernel.org>, stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, John Fleck <john.fleck@intel.com>, Feras Daoud <ferasda@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 20, 2018 at 09:36:53AM +0300, Erez Shitrit wrote:
> Hi,
> 
> Did you check the option to hold the netif_tx_lock_xxx() in
> ipoib_cm_rep_handler function (over the line
> set_bit(IPOIB_FLAG_OPER_UP)) instead of in the send data path flow?

That does seem better, then the test_bit in the datapath could become
non-atomic too :)

Jason
