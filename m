From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v3 iproute2-next 0/3] RDMA tool driver-specific resource
 tracking
Date: Fri, 18 May 2018 10:23:19 -0600
Message-ID: <6bfd8532-503e-3e37-87ea-83381d419b05@gmail.com>
References: <cover.1526483157.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1526483157.git.swise@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/16/18 9:05 AM, Steve Wise wrote:
> This series enhances the iproute2 rdma tool to include displaying
> driver-specific resource attributes.  It is the user-space part of the
> kernel driver resource tracking series that has been accepted for merging
> into linux-4.18 [1]
> 
> If there are no additional review comments, it can now be merged, I think.
> 

applied to iproute2-next.

BTW: Something is off with the header dependencies. After applying patch
1 nothing was rebuilt.
