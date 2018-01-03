From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH] ethernet: mlx4: Delete an error message for a failed
 memory allocation in five functions
Date: Wed, 3 Jan 2018 09:58:39 +0200
Message-ID: <0fea8f2f-f8fc-ce2e-3d33-44227de3637a@mellanox.com>
References: <30191db0-4d99-0349-b66a-c7354ef90d50@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30191db0-4d99-0349-b66a-c7354ef90d50@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 01/01/2018 10:46 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 1 Jan 2018 21:42:27 +0100
> 
> Omit an extra message for a memory allocation failure in these functions.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---

Is this an issue? Why? What is your motivation?
These are error messages, very informative, appear only upon errors, and 
in control flow.
