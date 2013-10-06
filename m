From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] An improved infrastructure for uverbs commands (My take
 at designing extensible scheme)
Date: Sun, 6 Oct 2013 11:28:02 +0300
Message-ID: <52511F12.8080406@mellanox.com>
References: <1380039392-15480-1-git-send-email-ydroneaud@opteya.com> <524AAAE6.3040508@mellanox.com> <524AB54F.9050205@mellanox.com> <a8f6521f905732e511576cbc3768f254@meuh.org> <524ACF03.3010302@mellanox.com> <7a32cf4322932c154e9bc145d8cf9ba0@meuh.org> <524ADCF1.80508@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <524ADCF1.80508-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Yan, 3.12-rc4 should be out today or tomorrow, if you still want to put 
such volume of change into the uverbs user/kernel extensions API, you 
should
post you final patch in the coming 1-2 days. This patch is too big  for 
-stable and we don't want to branch in user space depending if we work 
over 3.12 or later.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
