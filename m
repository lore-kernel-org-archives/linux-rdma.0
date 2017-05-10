From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: iwpmd init script does not work on Debian
Date: Wed, 10 May 2017 14:53:45 +0200
Message-ID: <1494420825.3739.4.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

the iwpmd init script specifies:

if [ -f "/etc/redhat-release" ]; then
        . /etc/rc.d/init.d/functions
        STARTD=daemon
        STOPD=killproc
        STATUSD=status
        GETPID=/sbin/pidof

elif [ -f "/etc/SuSE-release" ]; then
        . /lib/lsb/init-functions
        STARTD=start_daemon
        STOPD=killproc
        STATUSD=/sbin/checkproc
        GETPID=/sbin/pidofproc
fi

This does not work on Debian/Ubuntu. You can source /lib/lsb/init-
functions which provides the functions start_daemon, pidofproc,
killproc, status_of_proc.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
