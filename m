From: Joe Perches <joe@perches.com>
Subject: Re: KASAN: use-after-free Read in rds_tcp_tune
Date: Wed, 14 Feb 2018 09:02:08 -0800
Message-ID: <1518627728.3678.2.camel@perches.com>
References: <001a1141a524c513ca05628d8ad4@google.com>
         <20180112183046.GA26098@oracle.com>
         <CACT4Y+aB0dZShujVMJFV6grb_7AYOMca13a1J2AkWsT7R0cgrQ@mail.gmail.com>
         <20180214152109.GF11528@oracle.com>
         <CACT4Y+bKpi8he1ygwAxgm4F_RJ=BRPBPdMaVAK64SbvCVGt7ww@mail.gmail.com>
         <20180214153555.GG11528@oracle.com>
         <CACT4Y+ZZjE9fsnsQ-uab3RMt_Zpe98nKF1Pcj31ZGepYsi1UGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+ZZjE9fsnsQ-uab3RMt_Zpe98nKF1Pcj31ZGepYsi1UGA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>, Sowmini Varadhan <sowmini.varadhan@oracle.com>
Cc: syzbot <syzbot+bbd8e9a06452cc48059b@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-02-14 at 16:55 +0100, Dmitry Vyukov wrote:
> On Wed, Feb 14, 2018 at 4:35 PM, Sowmini Varadhan <sowmini.varadhan@oracle.com> wrote:
> > btw, checkpatch.pl complains about the syzbot*@syzkaller.appspotmail.com
> > addresses as "Unrecognized email address", we should fix that
> > error from checkpatch at some point.
> 
> Interesting. Looking at checkpatch.pl I think it wants all addresses
> to be in <>, i.e.
> Reported-by: <syzbot+bbd8e9a06452cc48059b@syzkaller.appspotmail.com>
> There probably was some reason to enforce this, so I think I will
> change the syzbot email template to include <>.
> Thanks!

Not really.

It's the somewhat unusual + in the address
that perl needs quoted before a substitution.

I believe this fixes it in checkpatch.
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3d4040322ae1..2b8397da39d3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1075,7 +1075,7 @@ sub parse_email {
 	} elsif ($formatted_email =~ /(\S+\@\S+)(.*)$/) {
 		$address = $1;
 		$comment = $2 if defined $2;
-		$formatted_email =~ s/$address.*$//;
+		$formatted_email =~ s/\Q$address\E.*$//;
 		$name = $formatted_email;
 		$name = trim($name);
 		$name =~ s/^\"|\"$//g;
