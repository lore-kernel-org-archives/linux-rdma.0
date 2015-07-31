From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Fri, 31 Jul 2015 16:32:52 -0700
Message-ID: <55BC05A4.1020403@sandisk.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BBF4B8.2050700@sandisk.com> <20150731223153.GA1518@obsidianresearch.com>
 <55BBFF03.7000505@sandisk.com> <20150731231430.GA1955@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------040309000703030400040701"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150731231430.GA1955-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--------------040309000703030400040701
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 07/31/2015 04:14 PM, Jason Gunthorpe wrote:
> Do you by chance have a straightforward recipe to setup SRP and SRPT
> on two Linux's for this simple purpose?

Some time ago I wrote a script that loads the upstream SRP target driver 
and creates two LUNs for local RAM disks (attached to this e-mail). The 
only disadvantage of that script is that it is based on the obsolete 
lio-utils package.

In case you would prefer the SCST SRP target driver, the following 
instructions should be sufficient to build, install, load and configure 
it on an RPM based system (please replace the GUID shown below by a GUID 
of a port of the HCA in your the target system):

svn co svn://svn.code.sf.net/p/scst/svn/trunk scst-trunk ||
   git clone https://github.com/bvanassche/scst.git scst-trunk
cd scst-trunk
make rpm
su
rpm -U {,scstadmin/}rpmbuilddir/RPMS/x86_64/*.rpm
cat <<EOF >/etc/scst.conf
HANDLER vdisk_blockio {
     DEVICE brd {
	filename /dev/ram0
     }
}
TARGET_DRIVER ib_srpt {
     TARGET fe80:0000:0000:0000:24be:05ff:ffa9:cbb1 {
         enabled 1
         LUN 0 brd
     }
}
EOF
modprobe brd
/etc/init.d/scst restart

Bart.

--------------040309000703030400040701
Content-Type: text/plain; charset="UTF-8"; name="restart-lio-srpt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="restart-lio-srpt"

IyEvYmluL2Jhc2gKCmZpbGVzaXplPSQoKDE2KjEwMjQqMTAyNCkpCmhjYXM9IiQoY2F0IC9z
eXMvZGV2aWNlcy8qLyovKi9pbmZpbmliYW5kLyovcG9ydHMvKi9naWRzLzAgfCBzZWQgJ3Mv
XlwoLi4uLlwpOlwoLi4uLlwpOlwoLi4uLlwpOlwoLi4uLlwpOlwoLi4uLlwpOlwoLi4uLlwp
OlwoLi4uLlwpOlwoLi4uLlwpJC8weDAwMDBcMlwzXDRcNVw2XDdcOCAweFw1XDZcN1w4IDB4
XDFcMlwzXDRcNVw2XDdcOC8nKSIKIyBPdXRwdXQgb2YgY2F0IC9zeXMvZGV2aWNlcy8qLyov
Ki9pbmZpbmliYW5kLyovcG9ydHMvKi9naWRzLzAgb24gdGhlIHJlbW90ZQojIHN5c3RlbXMK
aW5pdGlhdG9ycz0iXAoweDAwMDAwMDAwMDAwMDAwMDAwMDAyYzkwMzAwMDNjY2E3IFwKMHgw
MDAwMDAwMDAwMDAwMDAwMDAwMmM5MDMwMDAzY2NhOCBcCjB4MDAwMDAwMDAwMDAwMDAwMDAw
MDJjOTAzMDAwNWYzNGYgXAoweDAwMDAwMDAwMDAwMDAwMDAwMDAyYzkwMzAwMDVmMzUwIFwK
MHgwMDAwMDAwMDAwMDAwMDAwMDAwMmM5MDMwMGEzNDI3MSBcCjB4MDAwMDAwMDAwMDAwMDAw
MDAwMDJjOTAzMDBhMzQyNzIgXAoweDAwMDAwMDAwMDAwMDAwMDAwMDAyYzkwMzAwZmFiN2Yx
IFwKMHgwMDAwMDAwMDAwMDAwMDAwMDAwMmM5MDMwMGZhYjdmMiIKCmlmIFsgISAtZSAvc3lz
L21vZHVsZS9jb25maWdmcyBdOyB0aGVuCiAgbW9kcHJvYmUgY29uZmlnZnMKZmkKaWYgISBt
b3VudCB8IGdyZXAgLXF3IGNvbmZpZ2ZzOyB0aGVuCiAgbW91bnQgLXQgY29uZmlnZnMgbm9u
ZSAvc3lzL2tlcm5lbC9jb25maWcKZmkKCmlmIGNkIC9zeXMva2VybmVsL2NvbmZpZy90YXJn
ZXQgPiYvZGV2L251bGw7IHRoZW4KICBmb3IgaGNhIGluICR7aGNhc307IGRvCiAgICBpZiBb
IC1lIHNycHQvJGhjYS8kaGNhL2VuYWJsZSBdOyB0aGVuCiAgICAgIGVjaG8gMCA+c3JwdC8k
aGNhLyRoY2EvZW5hYmxlCiAgICBmaQogIGRvbmUKZmkKY2QgLwoKcm0gLWYgL3N5cy9rZXJu
ZWwvY29uZmlnL3RhcmdldC9zcnB0LyovKi9hY2xzLyovKi8qID4mL2Rldi9udWxsCnJtZGly
IC9zeXMva2VybmVsL2NvbmZpZy90YXJnZXQvc3JwdC8qLyovYWNscy8qLyogPiYvZGV2L251
bGwKcm1kaXIgL3N5cy9rZXJuZWwvY29uZmlnL3RhcmdldC9zcnB0LyovKi9hY2xzLyogPiYv
ZGV2L251bGwKcm0gLWYgL3N5cy9rZXJuZWwvY29uZmlnL3RhcmdldC9zcnB0LyovKi9sdW4v
Ki8qID4mL2Rldi9udWxsCnJtZGlyIC9zeXMva2VybmVsL2NvbmZpZy90YXJnZXQvc3JwdC8q
LyovbHVuLyogPiYvZGV2L251bGwKcm1kaXIgL3N5cy9rZXJuZWwvY29uZmlnL3RhcmdldC9z
cnB0LyovKiA+Ji9kZXYvbnVsbApybWRpciAvc3lzL2tlcm5lbC9jb25maWcvdGFyZ2V0L3Ny
cHQvKiA+Ji9kZXYvbnVsbApybWRpciAvc3lzL2tlcm5lbC9jb25maWcvdGFyZ2V0L3NycHQg
PiYvZGV2L251bGwKCmlmIFsgLWUgL3N5cy9tb2R1bGUvaWJfc3JwdCBdOyB0aGVuCiAgcm1t
b2QgaWJfc3JwdApmaQoKcm1kaXIgL3N5cy9rZXJuZWwvY29uZmlnL3RhcmdldC9jb3JlLyov
KiA+Ji9kZXYvbnVsbApybWRpciAvc3lzL2tlcm5lbC9jb25maWcvdGFyZ2V0L2NvcmUvKiA+
Ji9kZXYvbnVsbAoKI2ZpbmQgL3N5cy9rZXJuZWwvY29uZmlnL3RhcmdldAoKZm9yIG0gaW4g
aWJfc3JwdCB0YXJnZXRfY29yZV9wc2NzaSB0YXJnZXRfY29yZV9pYmxvY2sgdGFyZ2V0X2Nv
cmVfZmlsZSB0YXJnZXRfY29yZV9zdGd0IHRhcmdldF9jb3JlX3VzZXIgdGFyZ2V0X2NvcmVf
bW9kCmRvCiAgaWYgWyAtZSAvc3lzL21vZHVsZS8kbSBdOyB0aGVuCiAgICBybW1vZCAkbQog
IGZpCmRvbmUKCmlmIFsgIiQxIiA9ICJzdG9wIiBdOyB0aGVuCiAgZXhpdCAwCmZpCgptb2Rw
cm9iZSB0YXJnZXRfY29yZV9tb2QKCmlmIFsgLWUgL3N5cy9rZXJuZWwvZGVidWcvZHluYW1p
Y19kZWJ1Zy9jb250cm9sIF07IHRoZW4KICAjZWNobyAnbW9kdWxlIHRhcmdldF9jb3JlX21v
ZCArcCcgPiAvc3lzL2tlcm5lbC9kZWJ1Zy9keW5hbWljX2RlYnVnL2NvbnRyb2wKICA6CmZp
CgppbnNtb2QgL2xpYi9tb2R1bGVzLyQodW5hbWUgLXIpL2tlcm5lbC9kcml2ZXJzL2luZmlu
aWJhbmQvdWxwL3NycHQvaWJfc3JwdC5rbyBzcnBfbWF4X3JlcV9zaXplPTQyMDAgfHwgZXhp
dCAkPwoKaWYgWyAtZSAvc3lzL2tlcm5lbC9kZWJ1Zy9keW5hbWljX2RlYnVnL2NvbnRyb2wg
XTsgdGhlbgogIGVjaG8gJ21vZHVsZSBpYl9zcnB0ICtwJyA+IC9zeXMva2VybmVsL2RlYnVn
L2R5bmFtaWNfZGVidWcvY29udHJvbApmaQoKbW9kcHJvYmUgdGFyZ2V0X2NvcmVfZmlsZSB8
fCBleGl0ICQ/CmlmIFsgISAtZSAvZGV2L3JhbWRpc2sgXTsgdGhlbiAKICBkZCBpZj0vZGV2
L3plcm8gb2Y9L2Rldi9yYW1kaXNrIGJzPSR7ZmlsZXNpemV9IGNvdW50PTEKZmkKCmlmIGZh
bHNlICYmIGNkIC9zeXMva2VybmVsL2RlYnVnL3RyYWNpbmc7IHRoZW4KICBlY2hvIGZ1bmN0
aW9uID5jdXJyZW50X3RyYWNlcgogIHsgZWNobyAnc3JwdF8qJzsgZWNobyAndHJhbnNwb3J0
XyonOyB9ID5zZXRfZnRyYWNlX2ZpbHRlcgogIGVjaG8gMSA+dHJhY2luZ19vbgpmaQoKdmRl
djA9ImZpbGVpb18wL3ZkZXYwIgp2ZGV2MT0iZmlsZWlvXzEvdmRldjIiCnZkZXYyPSJyZF9k
cl8wL3ZkZXYxIgp2ZGV2cz0iJHZkZXYwICR2ZGV2MSIKdmRldl9jb3VudD0yCnRjbV9ub2Rl
IC0tZmlsZWlvICR2ZGV2MCAvZGV2L3JhbWRpc2sgJHtmaWxlc2l6ZX0KdGNtX25vZGUgLS1m
aWxlaW8gJHZkZXYxIC9kZXYvcmFtZGlzayA2NTUzNgppZiBbIC1lIC9zeXMva2VybmVsL2Nv
bmZpZy90YXJnZXQvY29yZS9yZF9kcl8wIF07IHRoZW4KICB0Y21fbm9kZSAtLXJhbWRpc2sg
JHZkZXYyIDIKICB2ZGV2cz0iJHZkZXZzIHZkZXYyIgogIHZkZXZfY291bnQ9MwpmaQpjZCAv
c3lzL2tlcm5lbC9jb25maWcvdGFyZ2V0IHx8IGV4aXQgJD8KbWtkaXIgc3JwdCB8fCBleGl0
ICQ/CmNkIHNycHQgfHwgZXhpdCAkPwpmb3IgaGNhIGluICR7aGNhc307IGRvCiAgbWtkaXIg
JGhjYQogIFsgLWUgJGhjYSBdIHx8IGNvbnRpbnVlCiAgZWNobyAkaGNhCiAgbWtkaXIgJGhj
YS8kaGNhCiAgaT0wCiAgZm9yIHYgaW4gJHt2ZGV2c307IGRvCiAgICBta2RpciAkaGNhLyRo
Y2EvbHVuL2x1bl8kaQogICAgKCBjZCAkaGNhLyRoY2EvbHVuL2x1bl8kaSAmJiBsbiAtcyAu
Li8uLi8uLi8uLi8uLi9jb3JlLyR2ICkKICAgIGk9JCgoaSsxKSkKICBkb25lCiAgZm9yIGlu
aSBpbiAke2luaXRpYXRvcnN9OyBkbwogICgKICAgIGNkICRoY2EvJGhjYS9hY2xzCiAgICBt
a2RpciAke2luaX0KICAgIGNkICR7aW5pfQogICAgZm9yICgoaSA9IDA7IGkgPCAkdmRldl9j
b3VudDsgaSsrKSkgZG8KICAgICAgKCBta2RpciBsdW5fJGkgJiYgY2QgbHVuXyRpICYmIGxu
IC1zIC4uLy4uLy4uL2x1bi9sdW5fJGkgKQogICAgZG9uZQogICkKICBlY2hvIDEgPiRoY2Ev
JGhjYS9lbmFibGUKICBkb25lCmRvbmUK
--------------040309000703030400040701--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
