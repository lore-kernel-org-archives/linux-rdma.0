From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 0/2] HW Device hot-removal support
Date: Tue, 18 Nov 2014 16:43:44 +0200
Message-ID: <546B5B20.8090902@mellanox.com>
References: <1416312682-7899-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416312682-7899-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/18/2014 2:11 PM, Yishai Hadas wrote:
> Changes from V0:
> patch #1: ib_uverbs_close, reduced mutex scope to enable tasks run in parallel.

Yishai, still some things to sort out here...1st, there must be away for 
us to come up with two patches that do not introduce 55 "line over 80 
characters" new checkaptch warnings on the code. Next, there are few 
more checkpatch warnings, please fix them up.

# ./scripts/checkpatch.pl --strict /tmp/disc_v1/* | grep WARN  | wc -l
59

# ./scripts/checkpatch.pl --strict /tmp/disc_v1/* | grep WARN  | grep 
"line over" | wc -l
55

# ./scripts/checkpatch.pl --strict /tmp/disc_v1/* | grep WARN  | sort -u
WARNING: line over 80 characters
WARNING: msleep < 20ms can sleep for up to 20ms; see 
Documentation/timers/timers-howto.txt
WARNING: sizeof *context should be sizeof(*context)
WARNING: sizeof *ev_file should be sizeof(*ev_file)
WARNING: sizeof *file should be sizeof(*file)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
