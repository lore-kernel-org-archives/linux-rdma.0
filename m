From: Aleksey Senin <alex-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Subject: [PATCH V1 0/4] New RAW_PACKET QP type
Date: Sun, 04 Jul 2010 16:35:03 +0300
Message-ID: <4C308E07.7050903@senin.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yiftah Shahar <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patches add a new QP type named RAW_PACKET.

This type of QP is used in Ethernet environment and intended for
creation of a whole packet, including L2 headers, from userspace. In
order to prevent regular user from creating malicious packets, at the
time of QP creation, kernel will check if the process has necessary
permissions. This examination areis done in uverbs layer and is general
for all low level drivers.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
