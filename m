From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v1 2/4] rdma: Add man pages for rdma system
 commands
Date: Fri, 31 May 2019 16:13:46 -0600
Message-ID: <6f0ff987-62d8-a314-6d9e-636363729d6a@gmail.com>
References: <20190531031117.60984-1-parav@mellanox.com>
 <20190531031117.60984-3-parav@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190531031117.60984-3-parav@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, stephen@networkplumber.org, leonro@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On 5/30/19 9:11 PM, Parav Pandit wrote:
> +
> +.SH SEE ALSO
> +.BR rdma (8),
> +.BR rdma-link (8),
> +.BR rdma-resource (8),
> +.BR network_namespaces(7),
> +.BR namespaces(7),

Added the missing space before (7) and applied all of them to iproute2-next.
