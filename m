From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-4.2] IB/mlx4: Fix and optimize SRIOV slave init
Date: Thu, 9 Jul 2015 17:02:34 +0300
Message-ID: <559E7EFA.3070805@mellanox.com>
References: <23f3dca9ff4b71155bd898be1f3cbd8eeb9df27f.1436394658.git.dledford@redhat.com>
 <559E30C3.5050702@mellanox.com> <559E69AD.9050406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559E69AD.9050406-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/9/2015 3:31 PM, Doug Ledford wrote:
>> i Doug,
>> >
>> >I'd like Jack to review this before we ack, not sure if he's in today,
>> >so he might get to look on that only on Sunday.
> Try to get it reviewed before then please.  If it passes my
> build/functional tests (which I want to get to today), it will go in a
> pull request tomorrow.

I hope Jack will be able to look on that -- I took a look -- seems fine. 
However, please (please) break it to two patches: one that fixes the 
leak and one that does the small optimization. Recently I came into a 
conclusion that each time we are violating the kernel practice of 
makingsure a patch has **one** logical change, we either add a bug or 
fix a bug in an unnoticed way, so...again, pull based on what tree/branch?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
