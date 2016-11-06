From: Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: rdma-core example spec file is broken
Date: Sun, 6 Nov 2016 14:01:20 +0200
Message-ID: <0e831337-e404-8973-b7fe-e176b3d688e8@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

The example spec file is broken after commit ddd530be4622 ("Minor RPM spec file improvments").

rpmbuild fails with the following error:

Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.7l0yoN
+ umask 022
+ cd /tmp/xxx/BUILD
+ cd rdma-core-11
/var/tmp/rpm-tmp.7l0yoN: line 31: syntax error near unexpected token `post'
error: Bad exit status from /var/tmp/rpm-tmp.7l0yoN (%build)


The issue is that the new "Requires" macros were added after the %prep and %build sections..

Regards,
Alaa

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
