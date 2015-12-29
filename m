From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 2/7] IB/mlx4: Add RoCE per GID support for
 add_gid and del_gid
Date: Tue, 29 Dec 2015 17:24:26 +0200
Message-ID: <5682A5AA.9040709@mellanox.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
 <1451395447-5198-3-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451395447-5198-3-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/29/2015 3:24 PM, Matan Barak wrote:
> [...] We use a new firmware command in order to populate the GID table and store the type along with the GID value.

Its a new value to existing command.. so better say we use a new value 
to the SET_PORT firmware command to do X

Also here, break out mlx4_core new functionality e.g the changes to 
include/linux/mlx4/cmd.h into mlx4_core only patch. You don't need any 
change to mlx4_core to have it's own patch, I guess one up to three mlx4 
core patches would be OK.

Did you make sure (at the resource tracker) that VFs can't do this new 
set port command flavor?

Also find some spot to put blank line in the change-log, it's hard to 
read this way.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
