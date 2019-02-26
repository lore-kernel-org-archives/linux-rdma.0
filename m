From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v1 iproute2-next 1/4] rdma: add helper rd_sendrecv_msg()
Date: Tue, 26 Feb 2019 12:55:43 -0700
Message-ID: <ef06b797-31a4-5424-5369-16c676b8c575@gmail.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <aa883bc5ffd63047cf57e2f9925002e7573fd7ac.1550773362.git.swise@opengridcomputing.com>
 <20190223092615.GM23561@mtr-leonro.mtl.com>
 <20190223093122.GO23561@mtr-leonro.mtl.com>
 <7f48fc85-45ab-fe7d-9614-4c5eb50f8401@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <7f48fc85-45ab-fe7d-9614-4c5eb50f8401@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leon@kernel.org>
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 2/26/19 10:19 AM, Steve Wise wrote:
> 
>> Will we need this recv_msg if we implement
>> extack support?
> 
> I'm not sure how extack works.  Do you know?

see devlink/mnlg.c

mnlg_socket_open()
{
	...
	mnl_socket_setsockopt(nlg->nl, NETLINK_EXT_ACK, &one, sizeof(one));
	...
}

and

mnlg_cb_error()

That code under devlink needs to be generic for both tools.
