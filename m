From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Issue with MLX5 IB driver
Date: Wed, 31 May 2017 12:44:26 -0700
Message-ID: <20170531194426.GA23120@infradead.org>
References: <ae8a8bbf-edb5-1909-824c-f98384f506b0@synopsys.com>
 <20170531161819.GK5406@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170531161819.GK5406-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 31, 2017 at 07:18:19PM +0300, Leon Romanovsky wrote:
> I think that you are hitting the side effect of these commits
> 7d0cc6edcc70 ("IB/mlx5: Add MR cache for large UMR regions") and
> 81713d3788d2 ("IB/mlx5: Add implicit MR support")
> 
> Do you have CONFIG_INFINIBAND_ON_DEMAND_PAGING on? Can you disable it
> for the test?

Eww.  Please make sure mlx5 gracefully handles cases where it can't use
crazy amount of memory, including disabling features like the above
at runtime when the required resources aren't available.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
