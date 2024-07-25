
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	87013103          	ld	sp,-1936(sp) # 80008870 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	613050ef          	jal	ra,80005e28 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0002e797          	auipc	a5,0x2e
    80000034:	21078793          	addi	a5,a5,528 # 8002e240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	7c8080e7          	jalr	1992(ra) # 80006822 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	868080e7          	jalr	-1944(ra) # 800068d6 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	24e080e7          	jalr	590(ra) # 800062d8 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	69e080e7          	jalr	1694(ra) # 80006792 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002e517          	auipc	a0,0x2e
    80000104:	14050513          	addi	a0,a0,320 # 8002e240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	6f6080e7          	jalr	1782(ra) # 80006822 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	792080e7          	jalr	1938(ra) # 800068d6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	768080e7          	jalr	1896(ra) # 800068d6 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	b22080e7          	jalr	-1246(ra) # 80000e50 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	b06080e7          	jalr	-1274(ra) # 80000e50 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	fc6080e7          	jalr	-58(ra) # 80006322 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	94a080e7          	jalr	-1718(ra) # 80001cb6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	43c080e7          	jalr	1084(ra) # 800057b0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	04e080e7          	jalr	78(ra) # 800013ca <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	e66080e7          	jalr	-410(ra) # 800061ea <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	17c080e7          	jalr	380(ra) # 80006508 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	f86080e7          	jalr	-122(ra) # 80006322 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	f76080e7          	jalr	-138(ra) # 80006322 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	f66080e7          	jalr	-154(ra) # 80006322 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	9c4080e7          	jalr	-1596(ra) # 80000da0 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	8aa080e7          	jalr	-1878(ra) # 80001c8e <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	8ca080e7          	jalr	-1846(ra) # 80001cb6 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	3a6080e7          	jalr	934(ra) # 8000579a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	3b4080e7          	jalr	948(ra) # 800057b0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	156080e7          	jalr	342(ra) # 8000255a <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	7e6080e7          	jalr	2022(ra) # 80002bf2 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	790080e7          	jalr	1936(ra) # 80003ba4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	4b6080e7          	jalr	1206(ra) # 800058d2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d30080e7          	jalr	-720(ra) # 80001154 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	e4a080e7          	jalr	-438(ra) # 800062d8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	d52080e7          	jalr	-686(ra) # 800062d8 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	d42080e7          	jalr	-702(ra) # 800062d8 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00006097          	auipc	ra,0x6
    80000614:	cc8080e7          	jalr	-824(ra) # 800062d8 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	632080e7          	jalr	1586(ra) # 80000d0a <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8bb6                	mv	s7,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      continue;
      // panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b05                	li	s6,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6a85                	lui	s5,0x1
    8000073a:	0535e963          	bltu	a1,s3,8000078c <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00006097          	auipc	ra,0x6
    80000760:	b7c080e7          	jalr	-1156(ra) # 800062d8 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00006097          	auipc	ra,0x6
    80000770:	b6c080e7          	jalr	-1172(ra) # 800062d8 <panic>
      uint64 pa = PTE2PA(*pte);
    80000774:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80000776:	00c79513          	slli	a0,a5,0xc
    8000077a:	00000097          	auipc	ra,0x0
    8000077e:	8a2080e7          	jalr	-1886(ra) # 8000001c <kfree>
    *pte = 0;
    80000782:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000786:	9956                	add	s2,s2,s5
    80000788:	fb397be3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000078c:	4601                	li	a2,0
    8000078e:	85ca                	mv	a1,s2
    80000790:	8552                	mv	a0,s4
    80000792:	00000097          	auipc	ra,0x0
    80000796:	cce080e7          	jalr	-818(ra) # 80000460 <walk>
    8000079a:	84aa                	mv	s1,a0
    8000079c:	d561                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000079e:	611c                	ld	a5,0(a0)
    800007a0:	0017f713          	andi	a4,a5,1
    800007a4:	d36d                	beqz	a4,80000786 <uvmunmap+0x78>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a6:	3ff7f713          	andi	a4,a5,1023
    800007aa:	fd670ee3          	beq	a4,s6,80000786 <uvmunmap+0x78>
    if(do_free){
    800007ae:	fc0b8ae3          	beqz	s7,80000782 <uvmunmap+0x74>
    800007b2:	b7c9                	j	80000774 <uvmunmap+0x66>

00000000800007b4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007b4:	1101                	addi	sp,sp,-32
    800007b6:	ec06                	sd	ra,24(sp)
    800007b8:	e822                	sd	s0,16(sp)
    800007ba:	e426                	sd	s1,8(sp)
    800007bc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007be:	00000097          	auipc	ra,0x0
    800007c2:	95a080e7          	jalr	-1702(ra) # 80000118 <kalloc>
    800007c6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007c8:	c519                	beqz	a0,800007d6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ca:	6605                	lui	a2,0x1
    800007cc:	4581                	li	a1,0
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	9aa080e7          	jalr	-1622(ra) # 80000178 <memset>
  return pagetable;
}
    800007d6:	8526                	mv	a0,s1
    800007d8:	60e2                	ld	ra,24(sp)
    800007da:	6442                	ld	s0,16(sp)
    800007dc:	64a2                	ld	s1,8(sp)
    800007de:	6105                	addi	sp,sp,32
    800007e0:	8082                	ret

00000000800007e2 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007e2:	7179                	addi	sp,sp,-48
    800007e4:	f406                	sd	ra,40(sp)
    800007e6:	f022                	sd	s0,32(sp)
    800007e8:	ec26                	sd	s1,24(sp)
    800007ea:	e84a                	sd	s2,16(sp)
    800007ec:	e44e                	sd	s3,8(sp)
    800007ee:	e052                	sd	s4,0(sp)
    800007f0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800007f2:	6785                	lui	a5,0x1
    800007f4:	04f67863          	bgeu	a2,a5,80000844 <uvminit+0x62>
    800007f8:	8a2a                	mv	s4,a0
    800007fa:	89ae                	mv	s3,a1
    800007fc:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	91a080e7          	jalr	-1766(ra) # 80000118 <kalloc>
    80000806:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000808:	6605                	lui	a2,0x1
    8000080a:	4581                	li	a1,0
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	96c080e7          	jalr	-1684(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000814:	4779                	li	a4,30
    80000816:	86ca                	mv	a3,s2
    80000818:	6605                	lui	a2,0x1
    8000081a:	4581                	li	a1,0
    8000081c:	8552                	mv	a0,s4
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	d2a080e7          	jalr	-726(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000826:	8626                	mv	a2,s1
    80000828:	85ce                	mv	a1,s3
    8000082a:	854a                	mv	a0,s2
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	9ac080e7          	jalr	-1620(ra) # 800001d8 <memmove>
}
    80000834:	70a2                	ld	ra,40(sp)
    80000836:	7402                	ld	s0,32(sp)
    80000838:	64e2                	ld	s1,24(sp)
    8000083a:	6942                	ld	s2,16(sp)
    8000083c:	69a2                	ld	s3,8(sp)
    8000083e:	6a02                	ld	s4,0(sp)
    80000840:	6145                	addi	sp,sp,48
    80000842:	8082                	ret
    panic("inituvm: more than a page");
    80000844:	00008517          	auipc	a0,0x8
    80000848:	86450513          	addi	a0,a0,-1948 # 800080a8 <etext+0xa8>
    8000084c:	00006097          	auipc	ra,0x6
    80000850:	a8c080e7          	jalr	-1396(ra) # 800062d8 <panic>

0000000080000854 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000085e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000860:	00b67d63          	bgeu	a2,a1,8000087a <uvmdealloc+0x26>
    80000864:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000866:	6785                	lui	a5,0x1
    80000868:	17fd                	addi	a5,a5,-1
    8000086a:	00f60733          	add	a4,a2,a5
    8000086e:	767d                	lui	a2,0xfffff
    80000870:	8f71                	and	a4,a4,a2
    80000872:	97ae                	add	a5,a5,a1
    80000874:	8ff1                	and	a5,a5,a2
    80000876:	00f76863          	bltu	a4,a5,80000886 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000087a:	8526                	mv	a0,s1
    8000087c:	60e2                	ld	ra,24(sp)
    8000087e:	6442                	ld	s0,16(sp)
    80000880:	64a2                	ld	s1,8(sp)
    80000882:	6105                	addi	sp,sp,32
    80000884:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000886:	8f99                	sub	a5,a5,a4
    80000888:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000088a:	4685                	li	a3,1
    8000088c:	0007861b          	sext.w	a2,a5
    80000890:	85ba                	mv	a1,a4
    80000892:	00000097          	auipc	ra,0x0
    80000896:	e7c080e7          	jalr	-388(ra) # 8000070e <uvmunmap>
    8000089a:	b7c5                	j	8000087a <uvmdealloc+0x26>

000000008000089c <uvmalloc>:
  if(newsz < oldsz)
    8000089c:	0ab66163          	bltu	a2,a1,8000093e <uvmalloc+0xa2>
{
    800008a0:	7139                	addi	sp,sp,-64
    800008a2:	fc06                	sd	ra,56(sp)
    800008a4:	f822                	sd	s0,48(sp)
    800008a6:	f426                	sd	s1,40(sp)
    800008a8:	f04a                	sd	s2,32(sp)
    800008aa:	ec4e                	sd	s3,24(sp)
    800008ac:	e852                	sd	s4,16(sp)
    800008ae:	e456                	sd	s5,8(sp)
    800008b0:	0080                	addi	s0,sp,64
    800008b2:	8aaa                	mv	s5,a0
    800008b4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008b6:	6985                	lui	s3,0x1
    800008b8:	19fd                	addi	s3,s3,-1
    800008ba:	95ce                	add	a1,a1,s3
    800008bc:	79fd                	lui	s3,0xfffff
    800008be:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008c2:	08c9f063          	bgeu	s3,a2,80000942 <uvmalloc+0xa6>
    800008c6:	894e                	mv	s2,s3
    mem = kalloc();
    800008c8:	00000097          	auipc	ra,0x0
    800008cc:	850080e7          	jalr	-1968(ra) # 80000118 <kalloc>
    800008d0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008d2:	c51d                	beqz	a0,80000900 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008d4:	6605                	lui	a2,0x1
    800008d6:	4581                	li	a1,0
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	8a0080e7          	jalr	-1888(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008e0:	4779                	li	a4,30
    800008e2:	86a6                	mv	a3,s1
    800008e4:	6605                	lui	a2,0x1
    800008e6:	85ca                	mv	a1,s2
    800008e8:	8556                	mv	a0,s5
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	c5e080e7          	jalr	-930(ra) # 80000548 <mappages>
    800008f2:	e905                	bnez	a0,80000922 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008f4:	6785                	lui	a5,0x1
    800008f6:	993e                	add	s2,s2,a5
    800008f8:	fd4968e3          	bltu	s2,s4,800008c8 <uvmalloc+0x2c>
  return newsz;
    800008fc:	8552                	mv	a0,s4
    800008fe:	a809                	j	80000910 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000900:	864e                	mv	a2,s3
    80000902:	85ca                	mv	a1,s2
    80000904:	8556                	mv	a0,s5
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	f4e080e7          	jalr	-178(ra) # 80000854 <uvmdealloc>
      return 0;
    8000090e:	4501                	li	a0,0
}
    80000910:	70e2                	ld	ra,56(sp)
    80000912:	7442                	ld	s0,48(sp)
    80000914:	74a2                	ld	s1,40(sp)
    80000916:	7902                	ld	s2,32(sp)
    80000918:	69e2                	ld	s3,24(sp)
    8000091a:	6a42                	ld	s4,16(sp)
    8000091c:	6aa2                	ld	s5,8(sp)
    8000091e:	6121                	addi	sp,sp,64
    80000920:	8082                	ret
      kfree(mem);
    80000922:	8526                	mv	a0,s1
    80000924:	fffff097          	auipc	ra,0xfffff
    80000928:	6f8080e7          	jalr	1784(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000092c:	864e                	mv	a2,s3
    8000092e:	85ca                	mv	a1,s2
    80000930:	8556                	mv	a0,s5
    80000932:	00000097          	auipc	ra,0x0
    80000936:	f22080e7          	jalr	-222(ra) # 80000854 <uvmdealloc>
      return 0;
    8000093a:	4501                	li	a0,0
    8000093c:	bfd1                	j	80000910 <uvmalloc+0x74>
    return oldsz;
    8000093e:	852e                	mv	a0,a1
}
    80000940:	8082                	ret
  return newsz;
    80000942:	8532                	mv	a0,a2
    80000944:	b7f1                	j	80000910 <uvmalloc+0x74>

0000000080000946 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000946:	7179                	addi	sp,sp,-48
    80000948:	f406                	sd	ra,40(sp)
    8000094a:	f022                	sd	s0,32(sp)
    8000094c:	ec26                	sd	s1,24(sp)
    8000094e:	e84a                	sd	s2,16(sp)
    80000950:	e44e                	sd	s3,8(sp)
    80000952:	e052                	sd	s4,0(sp)
    80000954:	1800                	addi	s0,sp,48
    80000956:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000958:	84aa                	mv	s1,a0
    8000095a:	6905                	lui	s2,0x1
    8000095c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000095e:	4985                	li	s3,1
    80000960:	a821                	j	80000978 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000962:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000964:	0532                	slli	a0,a0,0xc
    80000966:	00000097          	auipc	ra,0x0
    8000096a:	fe0080e7          	jalr	-32(ra) # 80000946 <freewalk>
      pagetable[i] = 0;
    8000096e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000972:	04a1                	addi	s1,s1,8
    80000974:	03248163          	beq	s1,s2,80000996 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000978:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097a:	00f57793          	andi	a5,a0,15
    8000097e:	ff3782e3          	beq	a5,s3,80000962 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000982:	8905                	andi	a0,a0,1
    80000984:	d57d                	beqz	a0,80000972 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000986:	00007517          	auipc	a0,0x7
    8000098a:	74250513          	addi	a0,a0,1858 # 800080c8 <etext+0xc8>
    8000098e:	00006097          	auipc	ra,0x6
    80000992:	94a080e7          	jalr	-1718(ra) # 800062d8 <panic>
    }
  }
  kfree((void*)pagetable);
    80000996:	8552                	mv	a0,s4
    80000998:	fffff097          	auipc	ra,0xfffff
    8000099c:	684080e7          	jalr	1668(ra) # 8000001c <kfree>
}
    800009a0:	70a2                	ld	ra,40(sp)
    800009a2:	7402                	ld	s0,32(sp)
    800009a4:	64e2                	ld	s1,24(sp)
    800009a6:	6942                	ld	s2,16(sp)
    800009a8:	69a2                	ld	s3,8(sp)
    800009aa:	6a02                	ld	s4,0(sp)
    800009ac:	6145                	addi	sp,sp,48
    800009ae:	8082                	ret

00000000800009b0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009b0:	1101                	addi	sp,sp,-32
    800009b2:	ec06                	sd	ra,24(sp)
    800009b4:	e822                	sd	s0,16(sp)
    800009b6:	e426                	sd	s1,8(sp)
    800009b8:	1000                	addi	s0,sp,32
    800009ba:	84aa                	mv	s1,a0
  if(sz > 0)
    800009bc:	e999                	bnez	a1,800009d2 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009be:	8526                	mv	a0,s1
    800009c0:	00000097          	auipc	ra,0x0
    800009c4:	f86080e7          	jalr	-122(ra) # 80000946 <freewalk>
}
    800009c8:	60e2                	ld	ra,24(sp)
    800009ca:	6442                	ld	s0,16(sp)
    800009cc:	64a2                	ld	s1,8(sp)
    800009ce:	6105                	addi	sp,sp,32
    800009d0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009d2:	6605                	lui	a2,0x1
    800009d4:	167d                	addi	a2,a2,-1
    800009d6:	962e                	add	a2,a2,a1
    800009d8:	4685                	li	a3,1
    800009da:	8231                	srli	a2,a2,0xc
    800009dc:	4581                	li	a1,0
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	d30080e7          	jalr	-720(ra) # 8000070e <uvmunmap>
    800009e6:	bfe1                	j	800009be <uvmfree+0xe>

00000000800009e8 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009e8:	c679                	beqz	a2,80000ab6 <uvmcopy+0xce>
{
    800009ea:	715d                	addi	sp,sp,-80
    800009ec:	e486                	sd	ra,72(sp)
    800009ee:	e0a2                	sd	s0,64(sp)
    800009f0:	fc26                	sd	s1,56(sp)
    800009f2:	f84a                	sd	s2,48(sp)
    800009f4:	f44e                	sd	s3,40(sp)
    800009f6:	f052                	sd	s4,32(sp)
    800009f8:	ec56                	sd	s5,24(sp)
    800009fa:	e85a                	sd	s6,16(sp)
    800009fc:	e45e                	sd	s7,8(sp)
    800009fe:	0880                	addi	s0,sp,80
    80000a00:	8b2a                	mv	s6,a0
    80000a02:	8aae                	mv	s5,a1
    80000a04:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a08:	4601                	li	a2,0
    80000a0a:	85ce                	mv	a1,s3
    80000a0c:	855a                	mv	a0,s6
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	a52080e7          	jalr	-1454(ra) # 80000460 <walk>
    80000a16:	c531                	beqz	a0,80000a62 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a18:	6118                	ld	a4,0(a0)
    80000a1a:	00177793          	andi	a5,a4,1
    80000a1e:	cbb1                	beqz	a5,80000a72 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a20:	00a75593          	srli	a1,a4,0xa
    80000a24:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a28:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a2c:	fffff097          	auipc	ra,0xfffff
    80000a30:	6ec080e7          	jalr	1772(ra) # 80000118 <kalloc>
    80000a34:	892a                	mv	s2,a0
    80000a36:	c939                	beqz	a0,80000a8c <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a38:	6605                	lui	a2,0x1
    80000a3a:	85de                	mv	a1,s7
    80000a3c:	fffff097          	auipc	ra,0xfffff
    80000a40:	79c080e7          	jalr	1948(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a44:	8726                	mv	a4,s1
    80000a46:	86ca                	mv	a3,s2
    80000a48:	6605                	lui	a2,0x1
    80000a4a:	85ce                	mv	a1,s3
    80000a4c:	8556                	mv	a0,s5
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	afa080e7          	jalr	-1286(ra) # 80000548 <mappages>
    80000a56:	e515                	bnez	a0,80000a82 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a58:	6785                	lui	a5,0x1
    80000a5a:	99be                	add	s3,s3,a5
    80000a5c:	fb49e6e3          	bltu	s3,s4,80000a08 <uvmcopy+0x20>
    80000a60:	a081                	j	80000aa0 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a62:	00007517          	auipc	a0,0x7
    80000a66:	67650513          	addi	a0,a0,1654 # 800080d8 <etext+0xd8>
    80000a6a:	00006097          	auipc	ra,0x6
    80000a6e:	86e080e7          	jalr	-1938(ra) # 800062d8 <panic>
      panic("uvmcopy: page not present");
    80000a72:	00007517          	auipc	a0,0x7
    80000a76:	68650513          	addi	a0,a0,1670 # 800080f8 <etext+0xf8>
    80000a7a:	00006097          	auipc	ra,0x6
    80000a7e:	85e080e7          	jalr	-1954(ra) # 800062d8 <panic>
      kfree(mem);
    80000a82:	854a                	mv	a0,s2
    80000a84:	fffff097          	auipc	ra,0xfffff
    80000a88:	598080e7          	jalr	1432(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a8c:	4685                	li	a3,1
    80000a8e:	00c9d613          	srli	a2,s3,0xc
    80000a92:	4581                	li	a1,0
    80000a94:	8556                	mv	a0,s5
    80000a96:	00000097          	auipc	ra,0x0
    80000a9a:	c78080e7          	jalr	-904(ra) # 8000070e <uvmunmap>
  return -1;
    80000a9e:	557d                	li	a0,-1
}
    80000aa0:	60a6                	ld	ra,72(sp)
    80000aa2:	6406                	ld	s0,64(sp)
    80000aa4:	74e2                	ld	s1,56(sp)
    80000aa6:	7942                	ld	s2,48(sp)
    80000aa8:	79a2                	ld	s3,40(sp)
    80000aaa:	7a02                	ld	s4,32(sp)
    80000aac:	6ae2                	ld	s5,24(sp)
    80000aae:	6b42                	ld	s6,16(sp)
    80000ab0:	6ba2                	ld	s7,8(sp)
    80000ab2:	6161                	addi	sp,sp,80
    80000ab4:	8082                	ret
  return 0;
    80000ab6:	4501                	li	a0,0
}
    80000ab8:	8082                	ret

0000000080000aba <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000aba:	1141                	addi	sp,sp,-16
    80000abc:	e406                	sd	ra,8(sp)
    80000abe:	e022                	sd	s0,0(sp)
    80000ac0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ac2:	4601                	li	a2,0
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	99c080e7          	jalr	-1636(ra) # 80000460 <walk>
  if(pte == 0)
    80000acc:	c901                	beqz	a0,80000adc <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ace:	611c                	ld	a5,0(a0)
    80000ad0:	9bbd                	andi	a5,a5,-17
    80000ad2:	e11c                	sd	a5,0(a0)
}
    80000ad4:	60a2                	ld	ra,8(sp)
    80000ad6:	6402                	ld	s0,0(sp)
    80000ad8:	0141                	addi	sp,sp,16
    80000ada:	8082                	ret
    panic("uvmclear");
    80000adc:	00007517          	auipc	a0,0x7
    80000ae0:	63c50513          	addi	a0,a0,1596 # 80008118 <etext+0x118>
    80000ae4:	00005097          	auipc	ra,0x5
    80000ae8:	7f4080e7          	jalr	2036(ra) # 800062d8 <panic>

0000000080000aec <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000aec:	c6bd                	beqz	a3,80000b5a <copyout+0x6e>
{
    80000aee:	715d                	addi	sp,sp,-80
    80000af0:	e486                	sd	ra,72(sp)
    80000af2:	e0a2                	sd	s0,64(sp)
    80000af4:	fc26                	sd	s1,56(sp)
    80000af6:	f84a                	sd	s2,48(sp)
    80000af8:	f44e                	sd	s3,40(sp)
    80000afa:	f052                	sd	s4,32(sp)
    80000afc:	ec56                	sd	s5,24(sp)
    80000afe:	e85a                	sd	s6,16(sp)
    80000b00:	e45e                	sd	s7,8(sp)
    80000b02:	e062                	sd	s8,0(sp)
    80000b04:	0880                	addi	s0,sp,80
    80000b06:	8b2a                	mv	s6,a0
    80000b08:	8c2e                	mv	s8,a1
    80000b0a:	8a32                	mv	s4,a2
    80000b0c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b0e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b10:	6a85                	lui	s5,0x1
    80000b12:	a015                	j	80000b36 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b14:	9562                	add	a0,a0,s8
    80000b16:	0004861b          	sext.w	a2,s1
    80000b1a:	85d2                	mv	a1,s4
    80000b1c:	41250533          	sub	a0,a0,s2
    80000b20:	fffff097          	auipc	ra,0xfffff
    80000b24:	6b8080e7          	jalr	1720(ra) # 800001d8 <memmove>

    len -= n;
    80000b28:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b2c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b2e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b32:	02098263          	beqz	s3,80000b56 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b36:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b3a:	85ca                	mv	a1,s2
    80000b3c:	855a                	mv	a0,s6
    80000b3e:	00000097          	auipc	ra,0x0
    80000b42:	9c8080e7          	jalr	-1592(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b46:	cd01                	beqz	a0,80000b5e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b48:	418904b3          	sub	s1,s2,s8
    80000b4c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b4e:	fc99f3e3          	bgeu	s3,s1,80000b14 <copyout+0x28>
    80000b52:	84ce                	mv	s1,s3
    80000b54:	b7c1                	j	80000b14 <copyout+0x28>
  }
  return 0;
    80000b56:	4501                	li	a0,0
    80000b58:	a021                	j	80000b60 <copyout+0x74>
    80000b5a:	4501                	li	a0,0
}
    80000b5c:	8082                	ret
      return -1;
    80000b5e:	557d                	li	a0,-1
}
    80000b60:	60a6                	ld	ra,72(sp)
    80000b62:	6406                	ld	s0,64(sp)
    80000b64:	74e2                	ld	s1,56(sp)
    80000b66:	7942                	ld	s2,48(sp)
    80000b68:	79a2                	ld	s3,40(sp)
    80000b6a:	7a02                	ld	s4,32(sp)
    80000b6c:	6ae2                	ld	s5,24(sp)
    80000b6e:	6b42                	ld	s6,16(sp)
    80000b70:	6ba2                	ld	s7,8(sp)
    80000b72:	6c02                	ld	s8,0(sp)
    80000b74:	6161                	addi	sp,sp,80
    80000b76:	8082                	ret

0000000080000b78 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b78:	c6bd                	beqz	a3,80000be6 <copyin+0x6e>
{
    80000b7a:	715d                	addi	sp,sp,-80
    80000b7c:	e486                	sd	ra,72(sp)
    80000b7e:	e0a2                	sd	s0,64(sp)
    80000b80:	fc26                	sd	s1,56(sp)
    80000b82:	f84a                	sd	s2,48(sp)
    80000b84:	f44e                	sd	s3,40(sp)
    80000b86:	f052                	sd	s4,32(sp)
    80000b88:	ec56                	sd	s5,24(sp)
    80000b8a:	e85a                	sd	s6,16(sp)
    80000b8c:	e45e                	sd	s7,8(sp)
    80000b8e:	e062                	sd	s8,0(sp)
    80000b90:	0880                	addi	s0,sp,80
    80000b92:	8b2a                	mv	s6,a0
    80000b94:	8a2e                	mv	s4,a1
    80000b96:	8c32                	mv	s8,a2
    80000b98:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b9a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b9c:	6a85                	lui	s5,0x1
    80000b9e:	a015                	j	80000bc2 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ba0:	9562                	add	a0,a0,s8
    80000ba2:	0004861b          	sext.w	a2,s1
    80000ba6:	412505b3          	sub	a1,a0,s2
    80000baa:	8552                	mv	a0,s4
    80000bac:	fffff097          	auipc	ra,0xfffff
    80000bb0:	62c080e7          	jalr	1580(ra) # 800001d8 <memmove>

    len -= n;
    80000bb4:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bb8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bba:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bbe:	02098263          	beqz	s3,80000be2 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bc2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bc6:	85ca                	mv	a1,s2
    80000bc8:	855a                	mv	a0,s6
    80000bca:	00000097          	auipc	ra,0x0
    80000bce:	93c080e7          	jalr	-1732(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bd2:	cd01                	beqz	a0,80000bea <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bd4:	418904b3          	sub	s1,s2,s8
    80000bd8:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bda:	fc99f3e3          	bgeu	s3,s1,80000ba0 <copyin+0x28>
    80000bde:	84ce                	mv	s1,s3
    80000be0:	b7c1                	j	80000ba0 <copyin+0x28>
  }
  return 0;
    80000be2:	4501                	li	a0,0
    80000be4:	a021                	j	80000bec <copyin+0x74>
    80000be6:	4501                	li	a0,0
}
    80000be8:	8082                	ret
      return -1;
    80000bea:	557d                	li	a0,-1
}
    80000bec:	60a6                	ld	ra,72(sp)
    80000bee:	6406                	ld	s0,64(sp)
    80000bf0:	74e2                	ld	s1,56(sp)
    80000bf2:	7942                	ld	s2,48(sp)
    80000bf4:	79a2                	ld	s3,40(sp)
    80000bf6:	7a02                	ld	s4,32(sp)
    80000bf8:	6ae2                	ld	s5,24(sp)
    80000bfa:	6b42                	ld	s6,16(sp)
    80000bfc:	6ba2                	ld	s7,8(sp)
    80000bfe:	6c02                	ld	s8,0(sp)
    80000c00:	6161                	addi	sp,sp,80
    80000c02:	8082                	ret

0000000080000c04 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c04:	c6c5                	beqz	a3,80000cac <copyinstr+0xa8>
{
    80000c06:	715d                	addi	sp,sp,-80
    80000c08:	e486                	sd	ra,72(sp)
    80000c0a:	e0a2                	sd	s0,64(sp)
    80000c0c:	fc26                	sd	s1,56(sp)
    80000c0e:	f84a                	sd	s2,48(sp)
    80000c10:	f44e                	sd	s3,40(sp)
    80000c12:	f052                	sd	s4,32(sp)
    80000c14:	ec56                	sd	s5,24(sp)
    80000c16:	e85a                	sd	s6,16(sp)
    80000c18:	e45e                	sd	s7,8(sp)
    80000c1a:	0880                	addi	s0,sp,80
    80000c1c:	8a2a                	mv	s4,a0
    80000c1e:	8b2e                	mv	s6,a1
    80000c20:	8bb2                	mv	s7,a2
    80000c22:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c24:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c26:	6985                	lui	s3,0x1
    80000c28:	a035                	j	80000c54 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c2a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c2e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c30:	0017b793          	seqz	a5,a5
    80000c34:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c38:	60a6                	ld	ra,72(sp)
    80000c3a:	6406                	ld	s0,64(sp)
    80000c3c:	74e2                	ld	s1,56(sp)
    80000c3e:	7942                	ld	s2,48(sp)
    80000c40:	79a2                	ld	s3,40(sp)
    80000c42:	7a02                	ld	s4,32(sp)
    80000c44:	6ae2                	ld	s5,24(sp)
    80000c46:	6b42                	ld	s6,16(sp)
    80000c48:	6ba2                	ld	s7,8(sp)
    80000c4a:	6161                	addi	sp,sp,80
    80000c4c:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c4e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c52:	c8a9                	beqz	s1,80000ca4 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c54:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c58:	85ca                	mv	a1,s2
    80000c5a:	8552                	mv	a0,s4
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	8aa080e7          	jalr	-1878(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c64:	c131                	beqz	a0,80000ca8 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c66:	41790833          	sub	a6,s2,s7
    80000c6a:	984e                	add	a6,a6,s3
    if(n > max)
    80000c6c:	0104f363          	bgeu	s1,a6,80000c72 <copyinstr+0x6e>
    80000c70:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c72:	955e                	add	a0,a0,s7
    80000c74:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c78:	fc080be3          	beqz	a6,80000c4e <copyinstr+0x4a>
    80000c7c:	985a                	add	a6,a6,s6
    80000c7e:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c80:	41650633          	sub	a2,a0,s6
    80000c84:	14fd                	addi	s1,s1,-1
    80000c86:	9b26                	add	s6,s6,s1
    80000c88:	00f60733          	add	a4,a2,a5
    80000c8c:	00074703          	lbu	a4,0(a4)
    80000c90:	df49                	beqz	a4,80000c2a <copyinstr+0x26>
        *dst = *p;
    80000c92:	00e78023          	sb	a4,0(a5)
      --max;
    80000c96:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000c9a:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c9c:	ff0796e3          	bne	a5,a6,80000c88 <copyinstr+0x84>
      dst++;
    80000ca0:	8b42                	mv	s6,a6
    80000ca2:	b775                	j	80000c4e <copyinstr+0x4a>
    80000ca4:	4781                	li	a5,0
    80000ca6:	b769                	j	80000c30 <copyinstr+0x2c>
      return -1;
    80000ca8:	557d                	li	a0,-1
    80000caa:	b779                	j	80000c38 <copyinstr+0x34>
  int got_null = 0;
    80000cac:	4781                	li	a5,0
  if(got_null){
    80000cae:	0017b793          	seqz	a5,a5
    80000cb2:	40f00533          	neg	a0,a5
}
    80000cb6:	8082                	ret

0000000080000cb8 <uvmgetdirty>:
//函数检查给定虚拟地址 va 对应的页表条目（PTE）是否设置了脏标记（PTE_D）
int uvmgetdirty(pagetable_t pagetable, uint64 va) {
    80000cb8:	1141                	addi	sp,sp,-16
    80000cba:	e406                	sd	ra,8(sp)
    80000cbc:	e022                	sd	s0,0(sp)
    80000cbe:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);//使用 walk 函数在页表中找到对应 va 的页表条目
    80000cc0:	4601                	li	a2,0
    80000cc2:	fffff097          	auipc	ra,0xfffff
    80000cc6:	79e080e7          	jalr	1950(ra) # 80000460 <walk>
  if(pte == 0) {
    80000cca:	c909                	beqz	a0,80000cdc <uvmgetdirty+0x24>
    return 0;
  }
  return (*pte & PTE_D);
    80000ccc:	6108                	ld	a0,0(a0)
    80000cce:	08057513          	andi	a0,a0,128
    80000cd2:	2501                	sext.w	a0,a0
}
    80000cd4:	60a2                	ld	ra,8(sp)
    80000cd6:	6402                	ld	s0,0(sp)
    80000cd8:	0141                	addi	sp,sp,16
    80000cda:	8082                	ret
    return 0;
    80000cdc:	4501                	li	a0,0
    80000cde:	bfdd                	j	80000cd4 <uvmgetdirty+0x1c>

0000000080000ce0 <uvmsetdirtywrite>:

// 设置给定虚拟地址 va 对应的页表条目的脏标记（PTE_D）和写标记（PTE_W）
int uvmsetdirtywrite(pagetable_t pagetable, uint64 va) {
    80000ce0:	1141                	addi	sp,sp,-16
    80000ce2:	e406                	sd	ra,8(sp)
    80000ce4:	e022                	sd	s0,0(sp)
    80000ce6:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000ce8:	4601                	li	a2,0
    80000cea:	fffff097          	auipc	ra,0xfffff
    80000cee:	776080e7          	jalr	1910(ra) # 80000460 <walk>
  if(pte == 0) {
    80000cf2:	c911                	beqz	a0,80000d06 <uvmsetdirtywrite+0x26>
    return -1;
  }
  *pte |= PTE_D | PTE_W;
    80000cf4:	611c                	ld	a5,0(a0)
    80000cf6:	0847e793          	ori	a5,a5,132
    80000cfa:	e11c                	sd	a5,0(a0)
  return 0;
    80000cfc:	4501                	li	a0,0
    80000cfe:	60a2                	ld	ra,8(sp)
    80000d00:	6402                	ld	s0,0(sp)
    80000d02:	0141                	addi	sp,sp,16
    80000d04:	8082                	ret
    return -1;
    80000d06:	557d                	li	a0,-1
    80000d08:	bfdd                	j	80000cfe <uvmsetdirtywrite+0x1e>

0000000080000d0a <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d0a:	7139                	addi	sp,sp,-64
    80000d0c:	fc06                	sd	ra,56(sp)
    80000d0e:	f822                	sd	s0,48(sp)
    80000d10:	f426                	sd	s1,40(sp)
    80000d12:	f04a                	sd	s2,32(sp)
    80000d14:	ec4e                	sd	s3,24(sp)
    80000d16:	e852                	sd	s4,16(sp)
    80000d18:	e456                	sd	s5,8(sp)
    80000d1a:	e05a                	sd	s6,0(sp)
    80000d1c:	0080                	addi	s0,sp,64
    80000d1e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d20:	00008497          	auipc	s1,0x8
    80000d24:	76048493          	addi	s1,s1,1888 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d28:	8b26                	mv	s6,s1
    80000d2a:	00007a97          	auipc	s5,0x7
    80000d2e:	2d6a8a93          	addi	s5,s5,726 # 80008000 <etext>
    80000d32:	04000937          	lui	s2,0x4000
    80000d36:	197d                	addi	s2,s2,-1
    80000d38:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3a:	00016a17          	auipc	s4,0x16
    80000d3e:	146a0a13          	addi	s4,s4,326 # 80016e80 <tickslock>
    char *pa = kalloc();
    80000d42:	fffff097          	auipc	ra,0xfffff
    80000d46:	3d6080e7          	jalr	982(ra) # 80000118 <kalloc>
    80000d4a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d4c:	c131                	beqz	a0,80000d90 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d4e:	416485b3          	sub	a1,s1,s6
    80000d52:	858d                	srai	a1,a1,0x3
    80000d54:	000ab783          	ld	a5,0(s5)
    80000d58:	02f585b3          	mul	a1,a1,a5
    80000d5c:	2585                	addiw	a1,a1,1
    80000d5e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d62:	4719                	li	a4,6
    80000d64:	6685                	lui	a3,0x1
    80000d66:	40b905b3          	sub	a1,s2,a1
    80000d6a:	854e                	mv	a0,s3
    80000d6c:	00000097          	auipc	ra,0x0
    80000d70:	87c080e7          	jalr	-1924(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d74:	36848493          	addi	s1,s1,872
    80000d78:	fd4495e3          	bne	s1,s4,80000d42 <proc_mapstacks+0x38>
  }
}
    80000d7c:	70e2                	ld	ra,56(sp)
    80000d7e:	7442                	ld	s0,48(sp)
    80000d80:	74a2                	ld	s1,40(sp)
    80000d82:	7902                	ld	s2,32(sp)
    80000d84:	69e2                	ld	s3,24(sp)
    80000d86:	6a42                	ld	s4,16(sp)
    80000d88:	6aa2                	ld	s5,8(sp)
    80000d8a:	6b02                	ld	s6,0(sp)
    80000d8c:	6121                	addi	sp,sp,64
    80000d8e:	8082                	ret
      panic("kalloc");
    80000d90:	00007517          	auipc	a0,0x7
    80000d94:	39850513          	addi	a0,a0,920 # 80008128 <etext+0x128>
    80000d98:	00005097          	auipc	ra,0x5
    80000d9c:	540080e7          	jalr	1344(ra) # 800062d8 <panic>

0000000080000da0 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000da0:	7139                	addi	sp,sp,-64
    80000da2:	fc06                	sd	ra,56(sp)
    80000da4:	f822                	sd	s0,48(sp)
    80000da6:	f426                	sd	s1,40(sp)
    80000da8:	f04a                	sd	s2,32(sp)
    80000daa:	ec4e                	sd	s3,24(sp)
    80000dac:	e852                	sd	s4,16(sp)
    80000dae:	e456                	sd	s5,8(sp)
    80000db0:	e05a                	sd	s6,0(sp)
    80000db2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000db4:	00007597          	auipc	a1,0x7
    80000db8:	37c58593          	addi	a1,a1,892 # 80008130 <etext+0x130>
    80000dbc:	00008517          	auipc	a0,0x8
    80000dc0:	29450513          	addi	a0,a0,660 # 80009050 <pid_lock>
    80000dc4:	00006097          	auipc	ra,0x6
    80000dc8:	9ce080e7          	jalr	-1586(ra) # 80006792 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dcc:	00007597          	auipc	a1,0x7
    80000dd0:	36c58593          	addi	a1,a1,876 # 80008138 <etext+0x138>
    80000dd4:	00008517          	auipc	a0,0x8
    80000dd8:	29450513          	addi	a0,a0,660 # 80009068 <wait_lock>
    80000ddc:	00006097          	auipc	ra,0x6
    80000de0:	9b6080e7          	jalr	-1610(ra) # 80006792 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de4:	00008497          	auipc	s1,0x8
    80000de8:	69c48493          	addi	s1,s1,1692 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dec:	00007b17          	auipc	s6,0x7
    80000df0:	35cb0b13          	addi	s6,s6,860 # 80008148 <etext+0x148>
      p->kstack = KSTACK((int) (p - proc));
    80000df4:	8aa6                	mv	s5,s1
    80000df6:	00007a17          	auipc	s4,0x7
    80000dfa:	20aa0a13          	addi	s4,s4,522 # 80008000 <etext>
    80000dfe:	04000937          	lui	s2,0x4000
    80000e02:	197d                	addi	s2,s2,-1
    80000e04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e06:	00016997          	auipc	s3,0x16
    80000e0a:	07a98993          	addi	s3,s3,122 # 80016e80 <tickslock>
      initlock(&p->lock, "proc");
    80000e0e:	85da                	mv	a1,s6
    80000e10:	8526                	mv	a0,s1
    80000e12:	00006097          	auipc	ra,0x6
    80000e16:	980080e7          	jalr	-1664(ra) # 80006792 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e1a:	415487b3          	sub	a5,s1,s5
    80000e1e:	878d                	srai	a5,a5,0x3
    80000e20:	000a3703          	ld	a4,0(s4)
    80000e24:	02e787b3          	mul	a5,a5,a4
    80000e28:	2785                	addiw	a5,a5,1
    80000e2a:	00d7979b          	slliw	a5,a5,0xd
    80000e2e:	40f907b3          	sub	a5,s2,a5
    80000e32:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	36848493          	addi	s1,s1,872
    80000e38:	fd349be3          	bne	s1,s3,80000e0e <procinit+0x6e>
  }
}
    80000e3c:	70e2                	ld	ra,56(sp)
    80000e3e:	7442                	ld	s0,48(sp)
    80000e40:	74a2                	ld	s1,40(sp)
    80000e42:	7902                	ld	s2,32(sp)
    80000e44:	69e2                	ld	s3,24(sp)
    80000e46:	6a42                	ld	s4,16(sp)
    80000e48:	6aa2                	ld	s5,8(sp)
    80000e4a:	6b02                	ld	s6,0(sp)
    80000e4c:	6121                	addi	sp,sp,64
    80000e4e:	8082                	ret

0000000080000e50 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e56:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e58:	2501                	sext.w	a0,a0
    80000e5a:	6422                	ld	s0,8(sp)
    80000e5c:	0141                	addi	sp,sp,16
    80000e5e:	8082                	ret

0000000080000e60 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e422                	sd	s0,8(sp)
    80000e64:	0800                	addi	s0,sp,16
    80000e66:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e6c:	00008517          	auipc	a0,0x8
    80000e70:	21450513          	addi	a0,a0,532 # 80009080 <cpus>
    80000e74:	953e                	add	a0,a0,a5
    80000e76:	6422                	ld	s0,8(sp)
    80000e78:	0141                	addi	sp,sp,16
    80000e7a:	8082                	ret

0000000080000e7c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e7c:	1101                	addi	sp,sp,-32
    80000e7e:	ec06                	sd	ra,24(sp)
    80000e80:	e822                	sd	s0,16(sp)
    80000e82:	e426                	sd	s1,8(sp)
    80000e84:	1000                	addi	s0,sp,32
  push_off();
    80000e86:	00006097          	auipc	ra,0x6
    80000e8a:	950080e7          	jalr	-1712(ra) # 800067d6 <push_off>
    80000e8e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e90:	2781                	sext.w	a5,a5
    80000e92:	079e                	slli	a5,a5,0x7
    80000e94:	00008717          	auipc	a4,0x8
    80000e98:	1bc70713          	addi	a4,a4,444 # 80009050 <pid_lock>
    80000e9c:	97ba                	add	a5,a5,a4
    80000e9e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ea0:	00006097          	auipc	ra,0x6
    80000ea4:	9d6080e7          	jalr	-1578(ra) # 80006876 <pop_off>
  return p;
}
    80000ea8:	8526                	mv	a0,s1
    80000eaa:	60e2                	ld	ra,24(sp)
    80000eac:	6442                	ld	s0,16(sp)
    80000eae:	64a2                	ld	s1,8(sp)
    80000eb0:	6105                	addi	sp,sp,32
    80000eb2:	8082                	ret

0000000080000eb4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eb4:	1141                	addi	sp,sp,-16
    80000eb6:	e406                	sd	ra,8(sp)
    80000eb8:	e022                	sd	s0,0(sp)
    80000eba:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ebc:	00000097          	auipc	ra,0x0
    80000ec0:	fc0080e7          	jalr	-64(ra) # 80000e7c <myproc>
    80000ec4:	00006097          	auipc	ra,0x6
    80000ec8:	a12080e7          	jalr	-1518(ra) # 800068d6 <release>

  if (first) {
    80000ecc:	00008797          	auipc	a5,0x8
    80000ed0:	9547a783          	lw	a5,-1708(a5) # 80008820 <first.1763>
    80000ed4:	eb89                	bnez	a5,80000ee6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ed6:	00001097          	auipc	ra,0x1
    80000eda:	df8080e7          	jalr	-520(ra) # 80001cce <usertrapret>
}
    80000ede:	60a2                	ld	ra,8(sp)
    80000ee0:	6402                	ld	s0,0(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret
    first = 0;
    80000ee6:	00008797          	auipc	a5,0x8
    80000eea:	9207ad23          	sw	zero,-1734(a5) # 80008820 <first.1763>
    fsinit(ROOTDEV);
    80000eee:	4505                	li	a0,1
    80000ef0:	00002097          	auipc	ra,0x2
    80000ef4:	c82080e7          	jalr	-894(ra) # 80002b72 <fsinit>
    80000ef8:	bff9                	j	80000ed6 <forkret+0x22>

0000000080000efa <allocpid>:
allocpid() {
    80000efa:	1101                	addi	sp,sp,-32
    80000efc:	ec06                	sd	ra,24(sp)
    80000efe:	e822                	sd	s0,16(sp)
    80000f00:	e426                	sd	s1,8(sp)
    80000f02:	e04a                	sd	s2,0(sp)
    80000f04:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f06:	00008917          	auipc	s2,0x8
    80000f0a:	14a90913          	addi	s2,s2,330 # 80009050 <pid_lock>
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00006097          	auipc	ra,0x6
    80000f14:	912080e7          	jalr	-1774(ra) # 80006822 <acquire>
  pid = nextpid;
    80000f18:	00008797          	auipc	a5,0x8
    80000f1c:	90c78793          	addi	a5,a5,-1780 # 80008824 <nextpid>
    80000f20:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f22:	0014871b          	addiw	a4,s1,1
    80000f26:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f28:	854a                	mv	a0,s2
    80000f2a:	00006097          	auipc	ra,0x6
    80000f2e:	9ac080e7          	jalr	-1620(ra) # 800068d6 <release>
}
    80000f32:	8526                	mv	a0,s1
    80000f34:	60e2                	ld	ra,24(sp)
    80000f36:	6442                	ld	s0,16(sp)
    80000f38:	64a2                	ld	s1,8(sp)
    80000f3a:	6902                	ld	s2,0(sp)
    80000f3c:	6105                	addi	sp,sp,32
    80000f3e:	8082                	ret

0000000080000f40 <proc_pagetable>:
{
    80000f40:	1101                	addi	sp,sp,-32
    80000f42:	ec06                	sd	ra,24(sp)
    80000f44:	e822                	sd	s0,16(sp)
    80000f46:	e426                	sd	s1,8(sp)
    80000f48:	e04a                	sd	s2,0(sp)
    80000f4a:	1000                	addi	s0,sp,32
    80000f4c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	866080e7          	jalr	-1946(ra) # 800007b4 <uvmcreate>
    80000f56:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f58:	c121                	beqz	a0,80000f98 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f5a:	4729                	li	a4,10
    80000f5c:	00006697          	auipc	a3,0x6
    80000f60:	0a468693          	addi	a3,a3,164 # 80007000 <_trampoline>
    80000f64:	6605                	lui	a2,0x1
    80000f66:	040005b7          	lui	a1,0x4000
    80000f6a:	15fd                	addi	a1,a1,-1
    80000f6c:	05b2                	slli	a1,a1,0xc
    80000f6e:	fffff097          	auipc	ra,0xfffff
    80000f72:	5da080e7          	jalr	1498(ra) # 80000548 <mappages>
    80000f76:	02054863          	bltz	a0,80000fa6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f7a:	4719                	li	a4,6
    80000f7c:	05893683          	ld	a3,88(s2)
    80000f80:	6605                	lui	a2,0x1
    80000f82:	020005b7          	lui	a1,0x2000
    80000f86:	15fd                	addi	a1,a1,-1
    80000f88:	05b6                	slli	a1,a1,0xd
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	5bc080e7          	jalr	1468(ra) # 80000548 <mappages>
    80000f94:	02054163          	bltz	a0,80000fb6 <proc_pagetable+0x76>
}
    80000f98:	8526                	mv	a0,s1
    80000f9a:	60e2                	ld	ra,24(sp)
    80000f9c:	6442                	ld	s0,16(sp)
    80000f9e:	64a2                	ld	s1,8(sp)
    80000fa0:	6902                	ld	s2,0(sp)
    80000fa2:	6105                	addi	sp,sp,32
    80000fa4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fa6:	4581                	li	a1,0
    80000fa8:	8526                	mv	a0,s1
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	a06080e7          	jalr	-1530(ra) # 800009b0 <uvmfree>
    return 0;
    80000fb2:	4481                	li	s1,0
    80000fb4:	b7d5                	j	80000f98 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb6:	4681                	li	a3,0
    80000fb8:	4605                	li	a2,1
    80000fba:	040005b7          	lui	a1,0x4000
    80000fbe:	15fd                	addi	a1,a1,-1
    80000fc0:	05b2                	slli	a1,a1,0xc
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000fcc:	4581                	li	a1,0
    80000fce:	8526                	mv	a0,s1
    80000fd0:	00000097          	auipc	ra,0x0
    80000fd4:	9e0080e7          	jalr	-1568(ra) # 800009b0 <uvmfree>
    return 0;
    80000fd8:	4481                	li	s1,0
    80000fda:	bf7d                	j	80000f98 <proc_pagetable+0x58>

0000000080000fdc <proc_freepagetable>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	e04a                	sd	s2,0(sp)
    80000fe6:	1000                	addi	s0,sp,32
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fec:	4681                	li	a3,0
    80000fee:	4605                	li	a2,1
    80000ff0:	040005b7          	lui	a1,0x4000
    80000ff4:	15fd                	addi	a1,a1,-1
    80000ff6:	05b2                	slli	a1,a1,0xc
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	716080e7          	jalr	1814(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	020005b7          	lui	a1,0x2000
    80001008:	15fd                	addi	a1,a1,-1
    8000100a:	05b6                	slli	a1,a1,0xd
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	700080e7          	jalr	1792(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80001016:	85ca                	mv	a1,s2
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	996080e7          	jalr	-1642(ra) # 800009b0 <uvmfree>
}
    80001022:	60e2                	ld	ra,24(sp)
    80001024:	6442                	ld	s0,16(sp)
    80001026:	64a2                	ld	s1,8(sp)
    80001028:	6902                	ld	s2,0(sp)
    8000102a:	6105                	addi	sp,sp,32
    8000102c:	8082                	ret

000000008000102e <freeproc>:
{
    8000102e:	1101                	addi	sp,sp,-32
    80001030:	ec06                	sd	ra,24(sp)
    80001032:	e822                	sd	s0,16(sp)
    80001034:	e426                	sd	s1,8(sp)
    80001036:	1000                	addi	s0,sp,32
    80001038:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000103a:	6d28                	ld	a0,88(a0)
    8000103c:	c509                	beqz	a0,80001046 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	fde080e7          	jalr	-34(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001046:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000104a:	68a8                	ld	a0,80(s1)
    8000104c:	c511                	beqz	a0,80001058 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000104e:	64ac                	ld	a1,72(s1)
    80001050:	00000097          	auipc	ra,0x0
    80001054:	f8c080e7          	jalr	-116(ra) # 80000fdc <proc_freepagetable>
  p->pagetable = 0;
    80001058:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000105c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001060:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001064:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001068:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000106c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001070:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001074:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001078:	0004ac23          	sw	zero,24(s1)
}
    8000107c:	60e2                	ld	ra,24(sp)
    8000107e:	6442                	ld	s0,16(sp)
    80001080:	64a2                	ld	s1,8(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret

0000000080001086 <allocproc>:
{
    80001086:	1101                	addi	sp,sp,-32
    80001088:	ec06                	sd	ra,24(sp)
    8000108a:	e822                	sd	s0,16(sp)
    8000108c:	e426                	sd	s1,8(sp)
    8000108e:	e04a                	sd	s2,0(sp)
    80001090:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001092:	00008497          	auipc	s1,0x8
    80001096:	3ee48493          	addi	s1,s1,1006 # 80009480 <proc>
    8000109a:	00016917          	auipc	s2,0x16
    8000109e:	de690913          	addi	s2,s2,-538 # 80016e80 <tickslock>
    acquire(&p->lock);
    800010a2:	8526                	mv	a0,s1
    800010a4:	00005097          	auipc	ra,0x5
    800010a8:	77e080e7          	jalr	1918(ra) # 80006822 <acquire>
    if(p->state == UNUSED) {
    800010ac:	4c9c                	lw	a5,24(s1)
    800010ae:	cf81                	beqz	a5,800010c6 <allocproc+0x40>
      release(&p->lock);
    800010b0:	8526                	mv	a0,s1
    800010b2:	00006097          	auipc	ra,0x6
    800010b6:	824080e7          	jalr	-2012(ra) # 800068d6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ba:	36848493          	addi	s1,s1,872
    800010be:	ff2492e3          	bne	s1,s2,800010a2 <allocproc+0x1c>
  return 0;
    800010c2:	4481                	li	s1,0
    800010c4:	a889                	j	80001116 <allocproc+0x90>
  p->pid = allocpid();
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	e34080e7          	jalr	-460(ra) # 80000efa <allocpid>
    800010ce:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010d0:	4785                	li	a5,1
    800010d2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	044080e7          	jalr	68(ra) # 80000118 <kalloc>
    800010dc:	892a                	mv	s2,a0
    800010de:	eca8                	sd	a0,88(s1)
    800010e0:	c131                	beqz	a0,80001124 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010e2:	8526                	mv	a0,s1
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	e5c080e7          	jalr	-420(ra) # 80000f40 <proc_pagetable>
    800010ec:	892a                	mv	s2,a0
    800010ee:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010f0:	c531                	beqz	a0,8000113c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010f2:	07000613          	li	a2,112
    800010f6:	4581                	li	a1,0
    800010f8:	06048513          	addi	a0,s1,96
    800010fc:	fffff097          	auipc	ra,0xfffff
    80001100:	07c080e7          	jalr	124(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001104:	00000797          	auipc	a5,0x0
    80001108:	db078793          	addi	a5,a5,-592 # 80000eb4 <forkret>
    8000110c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000110e:	60bc                	ld	a5,64(s1)
    80001110:	6705                	lui	a4,0x1
    80001112:	97ba                	add	a5,a5,a4
    80001114:	f4bc                	sd	a5,104(s1)
}
    80001116:	8526                	mv	a0,s1
    80001118:	60e2                	ld	ra,24(sp)
    8000111a:	6442                	ld	s0,16(sp)
    8000111c:	64a2                	ld	s1,8(sp)
    8000111e:	6902                	ld	s2,0(sp)
    80001120:	6105                	addi	sp,sp,32
    80001122:	8082                	ret
    freeproc(p);
    80001124:	8526                	mv	a0,s1
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f08080e7          	jalr	-248(ra) # 8000102e <freeproc>
    release(&p->lock);
    8000112e:	8526                	mv	a0,s1
    80001130:	00005097          	auipc	ra,0x5
    80001134:	7a6080e7          	jalr	1958(ra) # 800068d6 <release>
    return 0;
    80001138:	84ca                	mv	s1,s2
    8000113a:	bff1                	j	80001116 <allocproc+0x90>
    freeproc(p);
    8000113c:	8526                	mv	a0,s1
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	ef0080e7          	jalr	-272(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001146:	8526                	mv	a0,s1
    80001148:	00005097          	auipc	ra,0x5
    8000114c:	78e080e7          	jalr	1934(ra) # 800068d6 <release>
    return 0;
    80001150:	84ca                	mv	s1,s2
    80001152:	b7d1                	j	80001116 <allocproc+0x90>

0000000080001154 <userinit>:
{
    80001154:	1101                	addi	sp,sp,-32
    80001156:	ec06                	sd	ra,24(sp)
    80001158:	e822                	sd	s0,16(sp)
    8000115a:	e426                	sd	s1,8(sp)
    8000115c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000115e:	00000097          	auipc	ra,0x0
    80001162:	f28080e7          	jalr	-216(ra) # 80001086 <allocproc>
    80001166:	84aa                	mv	s1,a0
  initproc = p;
    80001168:	00008797          	auipc	a5,0x8
    8000116c:	eaa7b423          	sd	a0,-344(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001170:	03400613          	li	a2,52
    80001174:	00007597          	auipc	a1,0x7
    80001178:	6bc58593          	addi	a1,a1,1724 # 80008830 <initcode>
    8000117c:	6928                	ld	a0,80(a0)
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	664080e7          	jalr	1636(ra) # 800007e2 <uvminit>
  p->sz = PGSIZE;
    80001186:	6785                	lui	a5,0x1
    80001188:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000118a:	6cb8                	ld	a4,88(s1)
    8000118c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001190:	6cb8                	ld	a4,88(s1)
    80001192:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001194:	4641                	li	a2,16
    80001196:	00007597          	auipc	a1,0x7
    8000119a:	fba58593          	addi	a1,a1,-70 # 80008150 <etext+0x150>
    8000119e:	15848513          	addi	a0,s1,344
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	128080e7          	jalr	296(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800011aa:	00007517          	auipc	a0,0x7
    800011ae:	fb650513          	addi	a0,a0,-74 # 80008160 <etext+0x160>
    800011b2:	00002097          	auipc	ra,0x2
    800011b6:	3ee080e7          	jalr	1006(ra) # 800035a0 <namei>
    800011ba:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011be:	478d                	li	a5,3
    800011c0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011c2:	8526                	mv	a0,s1
    800011c4:	00005097          	auipc	ra,0x5
    800011c8:	712080e7          	jalr	1810(ra) # 800068d6 <release>
}
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret

00000000800011d6 <growproc>:
{
    800011d6:	1101                	addi	sp,sp,-32
    800011d8:	ec06                	sd	ra,24(sp)
    800011da:	e822                	sd	s0,16(sp)
    800011dc:	e426                	sd	s1,8(sp)
    800011de:	e04a                	sd	s2,0(sp)
    800011e0:	1000                	addi	s0,sp,32
    800011e2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	c98080e7          	jalr	-872(ra) # 80000e7c <myproc>
    800011ec:	892a                	mv	s2,a0
  sz = p->sz;
    800011ee:	652c                	ld	a1,72(a0)
    800011f0:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011f4:	00904f63          	bgtz	s1,80001212 <growproc+0x3c>
  } else if(n < 0){
    800011f8:	0204cc63          	bltz	s1,80001230 <growproc+0x5a>
  p->sz = sz;
    800011fc:	1602                	slli	a2,a2,0x20
    800011fe:	9201                	srli	a2,a2,0x20
    80001200:	04c93423          	sd	a2,72(s2)
  return 0;
    80001204:	4501                	li	a0,0
}
    80001206:	60e2                	ld	ra,24(sp)
    80001208:	6442                	ld	s0,16(sp)
    8000120a:	64a2                	ld	s1,8(sp)
    8000120c:	6902                	ld	s2,0(sp)
    8000120e:	6105                	addi	sp,sp,32
    80001210:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001212:	9e25                	addw	a2,a2,s1
    80001214:	1602                	slli	a2,a2,0x20
    80001216:	9201                	srli	a2,a2,0x20
    80001218:	1582                	slli	a1,a1,0x20
    8000121a:	9181                	srli	a1,a1,0x20
    8000121c:	6928                	ld	a0,80(a0)
    8000121e:	fffff097          	auipc	ra,0xfffff
    80001222:	67e080e7          	jalr	1662(ra) # 8000089c <uvmalloc>
    80001226:	0005061b          	sext.w	a2,a0
    8000122a:	fa69                	bnez	a2,800011fc <growproc+0x26>
      return -1;
    8000122c:	557d                	li	a0,-1
    8000122e:	bfe1                	j	80001206 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001230:	9e25                	addw	a2,a2,s1
    80001232:	1602                	slli	a2,a2,0x20
    80001234:	9201                	srli	a2,a2,0x20
    80001236:	1582                	slli	a1,a1,0x20
    80001238:	9181                	srli	a1,a1,0x20
    8000123a:	6928                	ld	a0,80(a0)
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	618080e7          	jalr	1560(ra) # 80000854 <uvmdealloc>
    80001244:	0005061b          	sext.w	a2,a0
    80001248:	bf55                	j	800011fc <growproc+0x26>

000000008000124a <fork>:
{
    8000124a:	7139                	addi	sp,sp,-64
    8000124c:	fc06                	sd	ra,56(sp)
    8000124e:	f822                	sd	s0,48(sp)
    80001250:	f426                	sd	s1,40(sp)
    80001252:	f04a                	sd	s2,32(sp)
    80001254:	ec4e                	sd	s3,24(sp)
    80001256:	e852                	sd	s4,16(sp)
    80001258:	e456                	sd	s5,8(sp)
    8000125a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	c20080e7          	jalr	-992(ra) # 80000e7c <myproc>
    80001264:	89aa                	mv	s3,a0
  if((np = allocproc()) == 0){
    80001266:	00000097          	auipc	ra,0x0
    8000126a:	e20080e7          	jalr	-480(ra) # 80001086 <allocproc>
    8000126e:	14050c63          	beqz	a0,800013c6 <fork+0x17c>
    80001272:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001274:	0489b603          	ld	a2,72(s3)
    80001278:	692c                	ld	a1,80(a0)
    8000127a:	0509b503          	ld	a0,80(s3)
    8000127e:	fffff097          	auipc	ra,0xfffff
    80001282:	76a080e7          	jalr	1898(ra) # 800009e8 <uvmcopy>
    80001286:	04054663          	bltz	a0,800012d2 <fork+0x88>
  np->sz = p->sz;
    8000128a:	0489b783          	ld	a5,72(s3)
    8000128e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001292:	0589b683          	ld	a3,88(s3)
    80001296:	87b6                	mv	a5,a3
    80001298:	058a3703          	ld	a4,88(s4)
    8000129c:	12068693          	addi	a3,a3,288
    800012a0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012a4:	6788                	ld	a0,8(a5)
    800012a6:	6b8c                	ld	a1,16(a5)
    800012a8:	6f90                	ld	a2,24(a5)
    800012aa:	01073023          	sd	a6,0(a4)
    800012ae:	e708                	sd	a0,8(a4)
    800012b0:	eb0c                	sd	a1,16(a4)
    800012b2:	ef10                	sd	a2,24(a4)
    800012b4:	02078793          	addi	a5,a5,32
    800012b8:	02070713          	addi	a4,a4,32
    800012bc:	fed792e3          	bne	a5,a3,800012a0 <fork+0x56>
  np->trapframe->a0 = 0;
    800012c0:	058a3783          	ld	a5,88(s4)
    800012c4:	0607b823          	sd	zero,112(a5)
    800012c8:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012cc:	15000913          	li	s2,336
    800012d0:	a03d                	j	800012fe <fork+0xb4>
    freeproc(np);
    800012d2:	8552                	mv	a0,s4
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	d5a080e7          	jalr	-678(ra) # 8000102e <freeproc>
    release(&np->lock);
    800012dc:	8552                	mv	a0,s4
    800012de:	00005097          	auipc	ra,0x5
    800012e2:	5f8080e7          	jalr	1528(ra) # 800068d6 <release>
    return -1;
    800012e6:	597d                	li	s2,-1
    800012e8:	a0e9                	j	800013b2 <fork+0x168>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ea:	00003097          	auipc	ra,0x3
    800012ee:	94c080e7          	jalr	-1716(ra) # 80003c36 <filedup>
    800012f2:	009a07b3          	add	a5,s4,s1
    800012f6:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012f8:	04a1                	addi	s1,s1,8
    800012fa:	01248763          	beq	s1,s2,80001308 <fork+0xbe>
    if(p->ofile[i])
    800012fe:	009987b3          	add	a5,s3,s1
    80001302:	6388                	ld	a0,0(a5)
    80001304:	f17d                	bnez	a0,800012ea <fork+0xa0>
    80001306:	bfcd                	j	800012f8 <fork+0xae>
  np->cwd = idup(p->cwd);
    80001308:	1509b503          	ld	a0,336(s3)
    8000130c:	00002097          	auipc	ra,0x2
    80001310:	aa0080e7          	jalr	-1376(ra) # 80002dac <idup>
    80001314:	14aa3823          	sd	a0,336(s4)
for (i = 0; i < NVMA; ++i) {
    80001318:	16898493          	addi	s1,s3,360
    8000131c:	180a0913          	addi	s2,s4,384
    80001320:	36898a93          	addi	s5,s3,872
    80001324:	a03d                	j	80001352 <fork+0x108>
      np->vma[i] = p->vma[i];
    80001326:	86be                	mv	a3,a5
    80001328:	6498                	ld	a4,8(s1)
    8000132a:	689c                	ld	a5,16(s1)
    8000132c:	6c88                	ld	a0,24(s1)
    8000132e:	fed93423          	sd	a3,-24(s2)
    80001332:	fee93823          	sd	a4,-16(s2)
    80001336:	fef93c23          	sd	a5,-8(s2)
    8000133a:	00a93023          	sd	a0,0(s2)
      filedup(np->vma[i].f);//增加计数
    8000133e:	00003097          	auipc	ra,0x3
    80001342:	8f8080e7          	jalr	-1800(ra) # 80003c36 <filedup>
for (i = 0; i < NVMA; ++i) {
    80001346:	02048493          	addi	s1,s1,32
    8000134a:	02090913          	addi	s2,s2,32
    8000134e:	01548563          	beq	s1,s5,80001358 <fork+0x10e>
    if (p->vma[i].addr) {
    80001352:	609c                	ld	a5,0(s1)
    80001354:	dbed                	beqz	a5,80001346 <fork+0xfc>
    80001356:	bfc1                	j	80001326 <fork+0xdc>
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001358:	4641                	li	a2,16
    8000135a:	15898593          	addi	a1,s3,344
    8000135e:	158a0513          	addi	a0,s4,344
    80001362:	fffff097          	auipc	ra,0xfffff
    80001366:	f68080e7          	jalr	-152(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    8000136a:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000136e:	8552                	mv	a0,s4
    80001370:	00005097          	auipc	ra,0x5
    80001374:	566080e7          	jalr	1382(ra) # 800068d6 <release>
  acquire(&wait_lock);
    80001378:	00008497          	auipc	s1,0x8
    8000137c:	cf048493          	addi	s1,s1,-784 # 80009068 <wait_lock>
    80001380:	8526                	mv	a0,s1
    80001382:	00005097          	auipc	ra,0x5
    80001386:	4a0080e7          	jalr	1184(ra) # 80006822 <acquire>
  np->parent = p;
    8000138a:	033a3c23          	sd	s3,56(s4)
  release(&wait_lock);
    8000138e:	8526                	mv	a0,s1
    80001390:	00005097          	auipc	ra,0x5
    80001394:	546080e7          	jalr	1350(ra) # 800068d6 <release>
  acquire(&np->lock);
    80001398:	8552                	mv	a0,s4
    8000139a:	00005097          	auipc	ra,0x5
    8000139e:	488080e7          	jalr	1160(ra) # 80006822 <acquire>
  np->state = RUNNABLE;
    800013a2:	478d                	li	a5,3
    800013a4:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013a8:	8552                	mv	a0,s4
    800013aa:	00005097          	auipc	ra,0x5
    800013ae:	52c080e7          	jalr	1324(ra) # 800068d6 <release>
}
    800013b2:	854a                	mv	a0,s2
    800013b4:	70e2                	ld	ra,56(sp)
    800013b6:	7442                	ld	s0,48(sp)
    800013b8:	74a2                	ld	s1,40(sp)
    800013ba:	7902                	ld	s2,32(sp)
    800013bc:	69e2                	ld	s3,24(sp)
    800013be:	6a42                	ld	s4,16(sp)
    800013c0:	6aa2                	ld	s5,8(sp)
    800013c2:	6121                	addi	sp,sp,64
    800013c4:	8082                	ret
    return -1;
    800013c6:	597d                	li	s2,-1
    800013c8:	b7ed                	j	800013b2 <fork+0x168>

00000000800013ca <scheduler>:
{
    800013ca:	7139                	addi	sp,sp,-64
    800013cc:	fc06                	sd	ra,56(sp)
    800013ce:	f822                	sd	s0,48(sp)
    800013d0:	f426                	sd	s1,40(sp)
    800013d2:	f04a                	sd	s2,32(sp)
    800013d4:	ec4e                	sd	s3,24(sp)
    800013d6:	e852                	sd	s4,16(sp)
    800013d8:	e456                	sd	s5,8(sp)
    800013da:	e05a                	sd	s6,0(sp)
    800013dc:	0080                	addi	s0,sp,64
    800013de:	8792                	mv	a5,tp
  int id = r_tp();
    800013e0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013e2:	00779a93          	slli	s5,a5,0x7
    800013e6:	00008717          	auipc	a4,0x8
    800013ea:	c6a70713          	addi	a4,a4,-918 # 80009050 <pid_lock>
    800013ee:	9756                	add	a4,a4,s5
    800013f0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013f4:	00008717          	auipc	a4,0x8
    800013f8:	c9470713          	addi	a4,a4,-876 # 80009088 <cpus+0x8>
    800013fc:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013fe:	498d                	li	s3,3
        p->state = RUNNING;
    80001400:	4b11                	li	s6,4
        c->proc = p;
    80001402:	079e                	slli	a5,a5,0x7
    80001404:	00008a17          	auipc	s4,0x8
    80001408:	c4ca0a13          	addi	s4,s4,-948 # 80009050 <pid_lock>
    8000140c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000140e:	00016917          	auipc	s2,0x16
    80001412:	a7290913          	addi	s2,s2,-1422 # 80016e80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001416:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000141a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000141e:	10079073          	csrw	sstatus,a5
    80001422:	00008497          	auipc	s1,0x8
    80001426:	05e48493          	addi	s1,s1,94 # 80009480 <proc>
    8000142a:	a03d                	j	80001458 <scheduler+0x8e>
        p->state = RUNNING;
    8000142c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001430:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001434:	06048593          	addi	a1,s1,96
    80001438:	8556                	mv	a0,s5
    8000143a:	00000097          	auipc	ra,0x0
    8000143e:	7ea080e7          	jalr	2026(ra) # 80001c24 <swtch>
        c->proc = 0;
    80001442:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001446:	8526                	mv	a0,s1
    80001448:	00005097          	auipc	ra,0x5
    8000144c:	48e080e7          	jalr	1166(ra) # 800068d6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001450:	36848493          	addi	s1,s1,872
    80001454:	fd2481e3          	beq	s1,s2,80001416 <scheduler+0x4c>
      acquire(&p->lock);
    80001458:	8526                	mv	a0,s1
    8000145a:	00005097          	auipc	ra,0x5
    8000145e:	3c8080e7          	jalr	968(ra) # 80006822 <acquire>
      if(p->state == RUNNABLE) {
    80001462:	4c9c                	lw	a5,24(s1)
    80001464:	ff3791e3          	bne	a5,s3,80001446 <scheduler+0x7c>
    80001468:	b7d1                	j	8000142c <scheduler+0x62>

000000008000146a <sched>:
{
    8000146a:	7179                	addi	sp,sp,-48
    8000146c:	f406                	sd	ra,40(sp)
    8000146e:	f022                	sd	s0,32(sp)
    80001470:	ec26                	sd	s1,24(sp)
    80001472:	e84a                	sd	s2,16(sp)
    80001474:	e44e                	sd	s3,8(sp)
    80001476:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001478:	00000097          	auipc	ra,0x0
    8000147c:	a04080e7          	jalr	-1532(ra) # 80000e7c <myproc>
    80001480:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001482:	00005097          	auipc	ra,0x5
    80001486:	326080e7          	jalr	806(ra) # 800067a8 <holding>
    8000148a:	c93d                	beqz	a0,80001500 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000148c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000148e:	2781                	sext.w	a5,a5
    80001490:	079e                	slli	a5,a5,0x7
    80001492:	00008717          	auipc	a4,0x8
    80001496:	bbe70713          	addi	a4,a4,-1090 # 80009050 <pid_lock>
    8000149a:	97ba                	add	a5,a5,a4
    8000149c:	0a87a703          	lw	a4,168(a5)
    800014a0:	4785                	li	a5,1
    800014a2:	06f71763          	bne	a4,a5,80001510 <sched+0xa6>
  if(p->state == RUNNING)
    800014a6:	4c98                	lw	a4,24(s1)
    800014a8:	4791                	li	a5,4
    800014aa:	06f70b63          	beq	a4,a5,80001520 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014ae:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014b2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014b4:	efb5                	bnez	a5,80001530 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014b6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014b8:	00008917          	auipc	s2,0x8
    800014bc:	b9890913          	addi	s2,s2,-1128 # 80009050 <pid_lock>
    800014c0:	2781                	sext.w	a5,a5
    800014c2:	079e                	slli	a5,a5,0x7
    800014c4:	97ca                	add	a5,a5,s2
    800014c6:	0ac7a983          	lw	s3,172(a5)
    800014ca:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014cc:	2781                	sext.w	a5,a5
    800014ce:	079e                	slli	a5,a5,0x7
    800014d0:	00008597          	auipc	a1,0x8
    800014d4:	bb858593          	addi	a1,a1,-1096 # 80009088 <cpus+0x8>
    800014d8:	95be                	add	a1,a1,a5
    800014da:	06048513          	addi	a0,s1,96
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	746080e7          	jalr	1862(ra) # 80001c24 <swtch>
    800014e6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014e8:	2781                	sext.w	a5,a5
    800014ea:	079e                	slli	a5,a5,0x7
    800014ec:	97ca                	add	a5,a5,s2
    800014ee:	0b37a623          	sw	s3,172(a5)
}
    800014f2:	70a2                	ld	ra,40(sp)
    800014f4:	7402                	ld	s0,32(sp)
    800014f6:	64e2                	ld	s1,24(sp)
    800014f8:	6942                	ld	s2,16(sp)
    800014fa:	69a2                	ld	s3,8(sp)
    800014fc:	6145                	addi	sp,sp,48
    800014fe:	8082                	ret
    panic("sched p->lock");
    80001500:	00007517          	auipc	a0,0x7
    80001504:	c6850513          	addi	a0,a0,-920 # 80008168 <etext+0x168>
    80001508:	00005097          	auipc	ra,0x5
    8000150c:	dd0080e7          	jalr	-560(ra) # 800062d8 <panic>
    panic("sched locks");
    80001510:	00007517          	auipc	a0,0x7
    80001514:	c6850513          	addi	a0,a0,-920 # 80008178 <etext+0x178>
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	dc0080e7          	jalr	-576(ra) # 800062d8 <panic>
    panic("sched running");
    80001520:	00007517          	auipc	a0,0x7
    80001524:	c6850513          	addi	a0,a0,-920 # 80008188 <etext+0x188>
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	db0080e7          	jalr	-592(ra) # 800062d8 <panic>
    panic("sched interruptible");
    80001530:	00007517          	auipc	a0,0x7
    80001534:	c6850513          	addi	a0,a0,-920 # 80008198 <etext+0x198>
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	da0080e7          	jalr	-608(ra) # 800062d8 <panic>

0000000080001540 <yield>:
{
    80001540:	1101                	addi	sp,sp,-32
    80001542:	ec06                	sd	ra,24(sp)
    80001544:	e822                	sd	s0,16(sp)
    80001546:	e426                	sd	s1,8(sp)
    80001548:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000154a:	00000097          	auipc	ra,0x0
    8000154e:	932080e7          	jalr	-1742(ra) # 80000e7c <myproc>
    80001552:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001554:	00005097          	auipc	ra,0x5
    80001558:	2ce080e7          	jalr	718(ra) # 80006822 <acquire>
  p->state = RUNNABLE;
    8000155c:	478d                	li	a5,3
    8000155e:	cc9c                	sw	a5,24(s1)
  sched();
    80001560:	00000097          	auipc	ra,0x0
    80001564:	f0a080e7          	jalr	-246(ra) # 8000146a <sched>
  release(&p->lock);
    80001568:	8526                	mv	a0,s1
    8000156a:	00005097          	auipc	ra,0x5
    8000156e:	36c080e7          	jalr	876(ra) # 800068d6 <release>
}
    80001572:	60e2                	ld	ra,24(sp)
    80001574:	6442                	ld	s0,16(sp)
    80001576:	64a2                	ld	s1,8(sp)
    80001578:	6105                	addi	sp,sp,32
    8000157a:	8082                	ret

000000008000157c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000157c:	7179                	addi	sp,sp,-48
    8000157e:	f406                	sd	ra,40(sp)
    80001580:	f022                	sd	s0,32(sp)
    80001582:	ec26                	sd	s1,24(sp)
    80001584:	e84a                	sd	s2,16(sp)
    80001586:	e44e                	sd	s3,8(sp)
    80001588:	1800                	addi	s0,sp,48
    8000158a:	89aa                	mv	s3,a0
    8000158c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	8ee080e7          	jalr	-1810(ra) # 80000e7c <myproc>
    80001596:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001598:	00005097          	auipc	ra,0x5
    8000159c:	28a080e7          	jalr	650(ra) # 80006822 <acquire>
  release(lk);
    800015a0:	854a                	mv	a0,s2
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	334080e7          	jalr	820(ra) # 800068d6 <release>

  // Go to sleep.
  p->chan = chan;
    800015aa:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015ae:	4789                	li	a5,2
    800015b0:	cc9c                	sw	a5,24(s1)

  sched();
    800015b2:	00000097          	auipc	ra,0x0
    800015b6:	eb8080e7          	jalr	-328(ra) # 8000146a <sched>

  // Tidy up.
  p->chan = 0;
    800015ba:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015be:	8526                	mv	a0,s1
    800015c0:	00005097          	auipc	ra,0x5
    800015c4:	316080e7          	jalr	790(ra) # 800068d6 <release>
  acquire(lk);
    800015c8:	854a                	mv	a0,s2
    800015ca:	00005097          	auipc	ra,0x5
    800015ce:	258080e7          	jalr	600(ra) # 80006822 <acquire>
}
    800015d2:	70a2                	ld	ra,40(sp)
    800015d4:	7402                	ld	s0,32(sp)
    800015d6:	64e2                	ld	s1,24(sp)
    800015d8:	6942                	ld	s2,16(sp)
    800015da:	69a2                	ld	s3,8(sp)
    800015dc:	6145                	addi	sp,sp,48
    800015de:	8082                	ret

00000000800015e0 <wait>:
{
    800015e0:	715d                	addi	sp,sp,-80
    800015e2:	e486                	sd	ra,72(sp)
    800015e4:	e0a2                	sd	s0,64(sp)
    800015e6:	fc26                	sd	s1,56(sp)
    800015e8:	f84a                	sd	s2,48(sp)
    800015ea:	f44e                	sd	s3,40(sp)
    800015ec:	f052                	sd	s4,32(sp)
    800015ee:	ec56                	sd	s5,24(sp)
    800015f0:	e85a                	sd	s6,16(sp)
    800015f2:	e45e                	sd	s7,8(sp)
    800015f4:	e062                	sd	s8,0(sp)
    800015f6:	0880                	addi	s0,sp,80
    800015f8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015fa:	00000097          	auipc	ra,0x0
    800015fe:	882080e7          	jalr	-1918(ra) # 80000e7c <myproc>
    80001602:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001604:	00008517          	auipc	a0,0x8
    80001608:	a6450513          	addi	a0,a0,-1436 # 80009068 <wait_lock>
    8000160c:	00005097          	auipc	ra,0x5
    80001610:	216080e7          	jalr	534(ra) # 80006822 <acquire>
    havekids = 0;
    80001614:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001616:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80001618:	00016997          	auipc	s3,0x16
    8000161c:	86898993          	addi	s3,s3,-1944 # 80016e80 <tickslock>
        havekids = 1;
    80001620:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001622:	00008c17          	auipc	s8,0x8
    80001626:	a46c0c13          	addi	s8,s8,-1466 # 80009068 <wait_lock>
    havekids = 0;
    8000162a:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000162c:	00008497          	auipc	s1,0x8
    80001630:	e5448493          	addi	s1,s1,-428 # 80009480 <proc>
    80001634:	a0bd                	j	800016a2 <wait+0xc2>
          pid = np->pid;
    80001636:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000163a:	000b0e63          	beqz	s6,80001656 <wait+0x76>
    8000163e:	4691                	li	a3,4
    80001640:	02c48613          	addi	a2,s1,44
    80001644:	85da                	mv	a1,s6
    80001646:	05093503          	ld	a0,80(s2)
    8000164a:	fffff097          	auipc	ra,0xfffff
    8000164e:	4a2080e7          	jalr	1186(ra) # 80000aec <copyout>
    80001652:	02054563          	bltz	a0,8000167c <wait+0x9c>
          freeproc(np);
    80001656:	8526                	mv	a0,s1
    80001658:	00000097          	auipc	ra,0x0
    8000165c:	9d6080e7          	jalr	-1578(ra) # 8000102e <freeproc>
          release(&np->lock);
    80001660:	8526                	mv	a0,s1
    80001662:	00005097          	auipc	ra,0x5
    80001666:	274080e7          	jalr	628(ra) # 800068d6 <release>
          release(&wait_lock);
    8000166a:	00008517          	auipc	a0,0x8
    8000166e:	9fe50513          	addi	a0,a0,-1538 # 80009068 <wait_lock>
    80001672:	00005097          	auipc	ra,0x5
    80001676:	264080e7          	jalr	612(ra) # 800068d6 <release>
          return pid;
    8000167a:	a09d                	j	800016e0 <wait+0x100>
            release(&np->lock);
    8000167c:	8526                	mv	a0,s1
    8000167e:	00005097          	auipc	ra,0x5
    80001682:	258080e7          	jalr	600(ra) # 800068d6 <release>
            release(&wait_lock);
    80001686:	00008517          	auipc	a0,0x8
    8000168a:	9e250513          	addi	a0,a0,-1566 # 80009068 <wait_lock>
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	248080e7          	jalr	584(ra) # 800068d6 <release>
            return -1;
    80001696:	59fd                	li	s3,-1
    80001698:	a0a1                	j	800016e0 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000169a:	36848493          	addi	s1,s1,872
    8000169e:	03348463          	beq	s1,s3,800016c6 <wait+0xe6>
      if(np->parent == p){
    800016a2:	7c9c                	ld	a5,56(s1)
    800016a4:	ff279be3          	bne	a5,s2,8000169a <wait+0xba>
        acquire(&np->lock);
    800016a8:	8526                	mv	a0,s1
    800016aa:	00005097          	auipc	ra,0x5
    800016ae:	178080e7          	jalr	376(ra) # 80006822 <acquire>
        if(np->state == ZOMBIE){
    800016b2:	4c9c                	lw	a5,24(s1)
    800016b4:	f94781e3          	beq	a5,s4,80001636 <wait+0x56>
        release(&np->lock);
    800016b8:	8526                	mv	a0,s1
    800016ba:	00005097          	auipc	ra,0x5
    800016be:	21c080e7          	jalr	540(ra) # 800068d6 <release>
        havekids = 1;
    800016c2:	8756                	mv	a4,s5
    800016c4:	bfd9                	j	8000169a <wait+0xba>
    if(!havekids || p->killed){
    800016c6:	c701                	beqz	a4,800016ce <wait+0xee>
    800016c8:	02892783          	lw	a5,40(s2)
    800016cc:	c79d                	beqz	a5,800016fa <wait+0x11a>
      release(&wait_lock);
    800016ce:	00008517          	auipc	a0,0x8
    800016d2:	99a50513          	addi	a0,a0,-1638 # 80009068 <wait_lock>
    800016d6:	00005097          	auipc	ra,0x5
    800016da:	200080e7          	jalr	512(ra) # 800068d6 <release>
      return -1;
    800016de:	59fd                	li	s3,-1
}
    800016e0:	854e                	mv	a0,s3
    800016e2:	60a6                	ld	ra,72(sp)
    800016e4:	6406                	ld	s0,64(sp)
    800016e6:	74e2                	ld	s1,56(sp)
    800016e8:	7942                	ld	s2,48(sp)
    800016ea:	79a2                	ld	s3,40(sp)
    800016ec:	7a02                	ld	s4,32(sp)
    800016ee:	6ae2                	ld	s5,24(sp)
    800016f0:	6b42                	ld	s6,16(sp)
    800016f2:	6ba2                	ld	s7,8(sp)
    800016f4:	6c02                	ld	s8,0(sp)
    800016f6:	6161                	addi	sp,sp,80
    800016f8:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016fa:	85e2                	mv	a1,s8
    800016fc:	854a                	mv	a0,s2
    800016fe:	00000097          	auipc	ra,0x0
    80001702:	e7e080e7          	jalr	-386(ra) # 8000157c <sleep>
    havekids = 0;
    80001706:	b715                	j	8000162a <wait+0x4a>

0000000080001708 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001708:	7139                	addi	sp,sp,-64
    8000170a:	fc06                	sd	ra,56(sp)
    8000170c:	f822                	sd	s0,48(sp)
    8000170e:	f426                	sd	s1,40(sp)
    80001710:	f04a                	sd	s2,32(sp)
    80001712:	ec4e                	sd	s3,24(sp)
    80001714:	e852                	sd	s4,16(sp)
    80001716:	e456                	sd	s5,8(sp)
    80001718:	0080                	addi	s0,sp,64
    8000171a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000171c:	00008497          	auipc	s1,0x8
    80001720:	d6448493          	addi	s1,s1,-668 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001724:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001726:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001728:	00015917          	auipc	s2,0x15
    8000172c:	75890913          	addi	s2,s2,1880 # 80016e80 <tickslock>
    80001730:	a821                	j	80001748 <wakeup+0x40>
        p->state = RUNNABLE;
    80001732:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001736:	8526                	mv	a0,s1
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	19e080e7          	jalr	414(ra) # 800068d6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001740:	36848493          	addi	s1,s1,872
    80001744:	03248463          	beq	s1,s2,8000176c <wakeup+0x64>
    if(p != myproc()){
    80001748:	fffff097          	auipc	ra,0xfffff
    8000174c:	734080e7          	jalr	1844(ra) # 80000e7c <myproc>
    80001750:	fea488e3          	beq	s1,a0,80001740 <wakeup+0x38>
      acquire(&p->lock);
    80001754:	8526                	mv	a0,s1
    80001756:	00005097          	auipc	ra,0x5
    8000175a:	0cc080e7          	jalr	204(ra) # 80006822 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000175e:	4c9c                	lw	a5,24(s1)
    80001760:	fd379be3          	bne	a5,s3,80001736 <wakeup+0x2e>
    80001764:	709c                	ld	a5,32(s1)
    80001766:	fd4798e3          	bne	a5,s4,80001736 <wakeup+0x2e>
    8000176a:	b7e1                	j	80001732 <wakeup+0x2a>
    }
  }
}
    8000176c:	70e2                	ld	ra,56(sp)
    8000176e:	7442                	ld	s0,48(sp)
    80001770:	74a2                	ld	s1,40(sp)
    80001772:	7902                	ld	s2,32(sp)
    80001774:	69e2                	ld	s3,24(sp)
    80001776:	6a42                	ld	s4,16(sp)
    80001778:	6aa2                	ld	s5,8(sp)
    8000177a:	6121                	addi	sp,sp,64
    8000177c:	8082                	ret

000000008000177e <reparent>:
{
    8000177e:	7179                	addi	sp,sp,-48
    80001780:	f406                	sd	ra,40(sp)
    80001782:	f022                	sd	s0,32(sp)
    80001784:	ec26                	sd	s1,24(sp)
    80001786:	e84a                	sd	s2,16(sp)
    80001788:	e44e                	sd	s3,8(sp)
    8000178a:	e052                	sd	s4,0(sp)
    8000178c:	1800                	addi	s0,sp,48
    8000178e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001790:	00008497          	auipc	s1,0x8
    80001794:	cf048493          	addi	s1,s1,-784 # 80009480 <proc>
      pp->parent = initproc;
    80001798:	00008a17          	auipc	s4,0x8
    8000179c:	878a0a13          	addi	s4,s4,-1928 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017a0:	00015997          	auipc	s3,0x15
    800017a4:	6e098993          	addi	s3,s3,1760 # 80016e80 <tickslock>
    800017a8:	a029                	j	800017b2 <reparent+0x34>
    800017aa:	36848493          	addi	s1,s1,872
    800017ae:	01348d63          	beq	s1,s3,800017c8 <reparent+0x4a>
    if(pp->parent == p){
    800017b2:	7c9c                	ld	a5,56(s1)
    800017b4:	ff279be3          	bne	a5,s2,800017aa <reparent+0x2c>
      pp->parent = initproc;
    800017b8:	000a3503          	ld	a0,0(s4)
    800017bc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017be:	00000097          	auipc	ra,0x0
    800017c2:	f4a080e7          	jalr	-182(ra) # 80001708 <wakeup>
    800017c6:	b7d5                	j	800017aa <reparent+0x2c>
}
    800017c8:	70a2                	ld	ra,40(sp)
    800017ca:	7402                	ld	s0,32(sp)
    800017cc:	64e2                	ld	s1,24(sp)
    800017ce:	6942                	ld	s2,16(sp)
    800017d0:	69a2                	ld	s3,8(sp)
    800017d2:	6a02                	ld	s4,0(sp)
    800017d4:	6145                	addi	sp,sp,48
    800017d6:	8082                	ret

00000000800017d8 <exit>:
{
    800017d8:	7135                	addi	sp,sp,-160
    800017da:	ed06                	sd	ra,152(sp)
    800017dc:	e922                	sd	s0,144(sp)
    800017de:	e526                	sd	s1,136(sp)
    800017e0:	e14a                	sd	s2,128(sp)
    800017e2:	fcce                	sd	s3,120(sp)
    800017e4:	f8d2                	sd	s4,112(sp)
    800017e6:	f4d6                	sd	s5,104(sp)
    800017e8:	f0da                	sd	s6,96(sp)
    800017ea:	ecde                	sd	s7,88(sp)
    800017ec:	e8e2                	sd	s8,80(sp)
    800017ee:	e4e6                	sd	s9,72(sp)
    800017f0:	e0ea                	sd	s10,64(sp)
    800017f2:	fc6e                	sd	s11,56(sp)
    800017f4:	1100                	addi	s0,sp,160
    800017f6:	f6a43423          	sd	a0,-152(s0)
  struct proc *p = myproc();
    800017fa:	fffff097          	auipc	ra,0xfffff
    800017fe:	682080e7          	jalr	1666(ra) # 80000e7c <myproc>
    80001802:	f6a43c23          	sd	a0,-136(s0)
  if(p == initproc)
    80001806:	00008797          	auipc	a5,0x8
    8000180a:	80a7b783          	ld	a5,-2038(a5) # 80009010 <initproc>
    8000180e:	f8043023          	sd	zero,-128(s0)
    80001812:	00a78c63          	beq	a5,a0,8000182a <exit+0x52>
    80001816:	16850c93          	addi	s9,a0,360
          n1 = min(maxsz, n - i);
    8000181a:	6785                	lui	a5,0x1
    8000181c:	c0078d93          	addi	s11,a5,-1024 # c00 <_entry-0x7ffff400>
    80001820:	c007879b          	addiw	a5,a5,-1024
    80001824:	f8f42423          	sw	a5,-120(s0)
    80001828:	aa99                	j	8000197e <exit+0x1a6>
    panic("init exiting");
    8000182a:	00007517          	auipc	a0,0x7
    8000182e:	98650513          	addi	a0,a0,-1658 # 800081b0 <etext+0x1b0>
    80001832:	00005097          	auipc	ra,0x5
    80001836:	aa6080e7          	jalr	-1370(ra) # 800062d8 <panic>
          n1 = min(maxsz, n - i);
    8000183a:	0009891b          	sext.w	s2,s3
          begin_op();
    8000183e:	00002097          	auipc	ra,0x2
    80001842:	f7e080e7          	jalr	-130(ra) # 800037bc <begin_op>
          ilock(vma->f->ip);
    80001846:	6c9c                	ld	a5,24(s1)
    80001848:	6f88                	ld	a0,24(a5)
    8000184a:	00001097          	auipc	ra,0x1
    8000184e:	5a0080e7          	jalr	1440(ra) # 80002dea <ilock>
          if (writei(vma->f->ip, 1, va + i, va - vma->addr + vma->offset + i, n1) != n1) {
    80001852:	48d4                	lw	a3,20(s1)
    80001854:	017686bb          	addw	a3,a3,s7
    80001858:	609c                	ld	a5,0(s1)
    8000185a:	9e9d                	subw	a3,a3,a5
    8000185c:	6c9c                	ld	a5,24(s1)
    8000185e:	874a                	mv	a4,s2
    80001860:	015686bb          	addw	a3,a3,s5
    80001864:	8662                	mv	a2,s8
    80001866:	4585                	li	a1,1
    80001868:	6f88                	ld	a0,24(a5)
    8000186a:	00002097          	auipc	ra,0x2
    8000186e:	92c080e7          	jalr	-1748(ra) # 80003196 <writei>
    80001872:	2501                	sext.w	a0,a0
    80001874:	03251763          	bne	a0,s2,800018a2 <exit+0xca>
          iunlock(vma->f->ip);
    80001878:	6c9c                	ld	a5,24(s1)
    8000187a:	6f88                	ld	a0,24(a5)
    8000187c:	00001097          	auipc	ra,0x1
    80001880:	630080e7          	jalr	1584(ra) # 80002eac <iunlock>
          end_op();
    80001884:	00002097          	auipc	ra,0x2
    80001888:	fb8080e7          	jalr	-72(ra) # 8000383c <end_op>
        for (r = 0; r < n; r += n1) {
    8000188c:	01498a3b          	addw	s4,s3,s4
    80001890:	056a7363          	bgeu	s4,s6,800018d6 <exit+0xfe>
          n1 = min(maxsz, n - i);
    80001894:	f8c42983          	lw	s3,-116(s0)
    80001898:	fbadf1e3          	bgeu	s11,s10,8000183a <exit+0x62>
    8000189c:	f8842983          	lw	s3,-120(s0)
    800018a0:	bf69                	j	8000183a <exit+0x62>
            iunlock(vma->f->ip);
    800018a2:	f7043783          	ld	a5,-144(s0)
    800018a6:	00579513          	slli	a0,a5,0x5
    800018aa:	f7843783          	ld	a5,-136(s0)
    800018ae:	953e                	add	a0,a0,a5
    800018b0:	18053783          	ld	a5,384(a0)
    800018b4:	6f88                	ld	a0,24(a5)
    800018b6:	00001097          	auipc	ra,0x1
    800018ba:	5f6080e7          	jalr	1526(ra) # 80002eac <iunlock>
            end_op();
    800018be:	00002097          	auipc	ra,0x2
    800018c2:	f7e080e7          	jalr	-130(ra) # 8000383c <end_op>
            panic("exit: writei failed");
    800018c6:	00007517          	auipc	a0,0x7
    800018ca:	8fa50513          	addi	a0,a0,-1798 # 800081c0 <etext+0x1c0>
    800018ce:	00005097          	auipc	ra,0x5
    800018d2:	a0a080e7          	jalr	-1526(ra) # 800062d8 <panic>
      for (va = vma->addr; va < vma->addr + vma->len; va += PGSIZE) {
    800018d6:	6785                	lui	a5,0x1
    800018d8:	9abe                	add	s5,s5,a5
    800018da:	9c3e                	add	s8,s8,a5
    800018dc:	449c                	lw	a5,8(s1)
    800018de:	6098                	ld	a4,0(s1)
    800018e0:	97ba                	add	a5,a5,a4
    800018e2:	04faf063          	bgeu	s5,a5,80001922 <exit+0x14a>
        if (uvmgetdirty(p->pagetable, va) == 0) {
    800018e6:	85d6                	mv	a1,s5
    800018e8:	f7843783          	ld	a5,-136(s0)
    800018ec:	6ba8                	ld	a0,80(a5)
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	3ca080e7          	jalr	970(ra) # 80000cb8 <uvmgetdirty>
    800018f6:	d165                	beqz	a0,800018d6 <exit+0xfe>
        n = min(PGSIZE, vma->addr + vma->len - va);
    800018f8:	0084ab03          	lw	s6,8(s1)
    800018fc:	609c                	ld	a5,0(s1)
    800018fe:	9b3e                	add	s6,s6,a5
    80001900:	415b0b33          	sub	s6,s6,s5
    80001904:	6785                	lui	a5,0x1
    80001906:	0167f363          	bgeu	a5,s6,8000190c <exit+0x134>
    8000190a:	6b05                	lui	s6,0x1
    8000190c:	2b01                	sext.w	s6,s6
        for (r = 0; r < n; r += n1) {
    8000190e:	fc0b04e3          	beqz	s6,800018d6 <exit+0xfe>
    80001912:	4a01                	li	s4,0
          n1 = min(maxsz, n - i);
    80001914:	417b07bb          	subw	a5,s6,s7
    80001918:	f8f42623          	sw	a5,-116(s0)
    8000191c:	00078d1b          	sext.w	s10,a5
    80001920:	bf95                	j	80001894 <exit+0xbc>
    uvmunmap(p->pagetable, vma->addr, (vma->len - 1) / PGSIZE + 1, 1);
    80001922:	4490                	lw	a2,8(s1)
    80001924:	fff6079b          	addiw	a5,a2,-1
    80001928:	41f7d61b          	sraiw	a2,a5,0x1f
    8000192c:	0146561b          	srliw	a2,a2,0x14
    80001930:	9e3d                	addw	a2,a2,a5
    80001932:	40c6561b          	sraiw	a2,a2,0xc
    80001936:	4685                	li	a3,1
    80001938:	2605                	addiw	a2,a2,1
    8000193a:	608c                	ld	a1,0(s1)
    8000193c:	f7843783          	ld	a5,-136(s0)
    80001940:	6ba8                	ld	a0,80(a5)
    80001942:	fffff097          	auipc	ra,0xfffff
    80001946:	dcc080e7          	jalr	-564(ra) # 8000070e <uvmunmap>
    vma->addr = 0;
    8000194a:	0004b023          	sd	zero,0(s1)
    vma->len = 0;
    8000194e:	0004a423          	sw	zero,8(s1)
    vma->offset = 0;
    80001952:	0004aa23          	sw	zero,20(s1)
    vma->flags = 0;
    80001956:	0004a823          	sw	zero,16(s1)
    fileclose(vma->f);
    8000195a:	6c88                	ld	a0,24(s1)
    8000195c:	00002097          	auipc	ra,0x2
    80001960:	32c080e7          	jalr	812(ra) # 80003c88 <fileclose>
    vma->f = 0;
    80001964:	0004bc23          	sd	zero,24(s1)
  for (i = 0; i < NVMA; ++i) {
    80001968:	f8043783          	ld	a5,-128(s0)
    8000196c:	0785                	addi	a5,a5,1
    8000196e:	873e                	mv	a4,a5
    80001970:	f8f43023          	sd	a5,-128(s0)
    80001974:	020c8c93          	addi	s9,s9,32
    80001978:	47c1                	li	a5,16
    8000197a:	02f70963          	beq	a4,a5,800019ac <exit+0x1d4>
    8000197e:	f8043683          	ld	a3,-128(s0)
    80001982:	00068b9b          	sext.w	s7,a3
    80001986:	f7743823          	sd	s7,-144(s0)
    if (p->vma[i].addr == 0) {
    8000198a:	84e6                	mv	s1,s9
    8000198c:	000cba83          	ld	s5,0(s9)
    80001990:	fc0a8ce3          	beqz	s5,80001968 <exit+0x190>
    if ((vma->flags & MAP_SHARED)) {
    80001994:	010ca783          	lw	a5,16(s9)
    80001998:	8b85                	andi	a5,a5,1
    8000199a:	d7c1                	beqz	a5,80001922 <exit+0x14a>
      for (va = vma->addr; va < vma->addr + vma->len; va += PGSIZE) {
    8000199c:	008ca783          	lw	a5,8(s9)
    800019a0:	97d6                	add	a5,a5,s5
    800019a2:	f8faf0e3          	bgeu	s5,a5,80001922 <exit+0x14a>
    800019a6:	00da8c33          	add	s8,s5,a3
    800019aa:	bf35                	j	800018e6 <exit+0x10e>
    800019ac:	f7843783          	ld	a5,-136(s0)
    800019b0:	0d078493          	addi	s1,a5,208 # 10d0 <_entry-0x7fffef30>
    800019b4:	15078913          	addi	s2,a5,336
    800019b8:	a811                	j	800019cc <exit+0x1f4>
      fileclose(f);
    800019ba:	00002097          	auipc	ra,0x2
    800019be:	2ce080e7          	jalr	718(ra) # 80003c88 <fileclose>
      p->ofile[fd] = 0;
    800019c2:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800019c6:	04a1                	addi	s1,s1,8
    800019c8:	00990563          	beq	s2,s1,800019d2 <exit+0x1fa>
    if(p->ofile[fd]){
    800019cc:	6088                	ld	a0,0(s1)
    800019ce:	f575                	bnez	a0,800019ba <exit+0x1e2>
    800019d0:	bfdd                	j	800019c6 <exit+0x1ee>
  begin_op();
    800019d2:	00002097          	auipc	ra,0x2
    800019d6:	dea080e7          	jalr	-534(ra) # 800037bc <begin_op>
  iput(p->cwd);
    800019da:	f7843903          	ld	s2,-136(s0)
    800019de:	15093503          	ld	a0,336(s2)
    800019e2:	00001097          	auipc	ra,0x1
    800019e6:	5c2080e7          	jalr	1474(ra) # 80002fa4 <iput>
  end_op();
    800019ea:	00002097          	auipc	ra,0x2
    800019ee:	e52080e7          	jalr	-430(ra) # 8000383c <end_op>
  p->cwd = 0;
    800019f2:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    800019f6:	00007497          	auipc	s1,0x7
    800019fa:	67248493          	addi	s1,s1,1650 # 80009068 <wait_lock>
    800019fe:	8526                	mv	a0,s1
    80001a00:	00005097          	auipc	ra,0x5
    80001a04:	e22080e7          	jalr	-478(ra) # 80006822 <acquire>
  reparent(p);
    80001a08:	854a                	mv	a0,s2
    80001a0a:	00000097          	auipc	ra,0x0
    80001a0e:	d74080e7          	jalr	-652(ra) # 8000177e <reparent>
  wakeup(p->parent);
    80001a12:	03893503          	ld	a0,56(s2)
    80001a16:	00000097          	auipc	ra,0x0
    80001a1a:	cf2080e7          	jalr	-782(ra) # 80001708 <wakeup>
  acquire(&p->lock);
    80001a1e:	854a                	mv	a0,s2
    80001a20:	00005097          	auipc	ra,0x5
    80001a24:	e02080e7          	jalr	-510(ra) # 80006822 <acquire>
  p->xstate = status;
    80001a28:	f6843783          	ld	a5,-152(s0)
    80001a2c:	02f92623          	sw	a5,44(s2)
  p->state = ZOMBIE;
    80001a30:	4795                	li	a5,5
    80001a32:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    80001a36:	8526                	mv	a0,s1
    80001a38:	00005097          	auipc	ra,0x5
    80001a3c:	e9e080e7          	jalr	-354(ra) # 800068d6 <release>
  sched();
    80001a40:	00000097          	auipc	ra,0x0
    80001a44:	a2a080e7          	jalr	-1494(ra) # 8000146a <sched>
  panic("zombie exit");
    80001a48:	00006517          	auipc	a0,0x6
    80001a4c:	79050513          	addi	a0,a0,1936 # 800081d8 <etext+0x1d8>
    80001a50:	00005097          	auipc	ra,0x5
    80001a54:	888080e7          	jalr	-1912(ra) # 800062d8 <panic>

0000000080001a58 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a58:	7179                	addi	sp,sp,-48
    80001a5a:	f406                	sd	ra,40(sp)
    80001a5c:	f022                	sd	s0,32(sp)
    80001a5e:	ec26                	sd	s1,24(sp)
    80001a60:	e84a                	sd	s2,16(sp)
    80001a62:	e44e                	sd	s3,8(sp)
    80001a64:	1800                	addi	s0,sp,48
    80001a66:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a68:	00008497          	auipc	s1,0x8
    80001a6c:	a1848493          	addi	s1,s1,-1512 # 80009480 <proc>
    80001a70:	00015997          	auipc	s3,0x15
    80001a74:	41098993          	addi	s3,s3,1040 # 80016e80 <tickslock>
    acquire(&p->lock);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	00005097          	auipc	ra,0x5
    80001a7e:	da8080e7          	jalr	-600(ra) # 80006822 <acquire>
    if(p->pid == pid){
    80001a82:	589c                	lw	a5,48(s1)
    80001a84:	01278d63          	beq	a5,s2,80001a9e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	00005097          	auipc	ra,0x5
    80001a8e:	e4c080e7          	jalr	-436(ra) # 800068d6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a92:	36848493          	addi	s1,s1,872
    80001a96:	ff3491e3          	bne	s1,s3,80001a78 <kill+0x20>
  }
  return -1;
    80001a9a:	557d                	li	a0,-1
    80001a9c:	a829                	j	80001ab6 <kill+0x5e>
      p->killed = 1;
    80001a9e:	4785                	li	a5,1
    80001aa0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001aa2:	4c98                	lw	a4,24(s1)
    80001aa4:	4789                	li	a5,2
    80001aa6:	00f70f63          	beq	a4,a5,80001ac4 <kill+0x6c>
      release(&p->lock);
    80001aaa:	8526                	mv	a0,s1
    80001aac:	00005097          	auipc	ra,0x5
    80001ab0:	e2a080e7          	jalr	-470(ra) # 800068d6 <release>
      return 0;
    80001ab4:	4501                	li	a0,0
}
    80001ab6:	70a2                	ld	ra,40(sp)
    80001ab8:	7402                	ld	s0,32(sp)
    80001aba:	64e2                	ld	s1,24(sp)
    80001abc:	6942                	ld	s2,16(sp)
    80001abe:	69a2                	ld	s3,8(sp)
    80001ac0:	6145                	addi	sp,sp,48
    80001ac2:	8082                	ret
        p->state = RUNNABLE;
    80001ac4:	478d                	li	a5,3
    80001ac6:	cc9c                	sw	a5,24(s1)
    80001ac8:	b7cd                	j	80001aaa <kill+0x52>

0000000080001aca <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001aca:	7179                	addi	sp,sp,-48
    80001acc:	f406                	sd	ra,40(sp)
    80001ace:	f022                	sd	s0,32(sp)
    80001ad0:	ec26                	sd	s1,24(sp)
    80001ad2:	e84a                	sd	s2,16(sp)
    80001ad4:	e44e                	sd	s3,8(sp)
    80001ad6:	e052                	sd	s4,0(sp)
    80001ad8:	1800                	addi	s0,sp,48
    80001ada:	84aa                	mv	s1,a0
    80001adc:	892e                	mv	s2,a1
    80001ade:	89b2                	mv	s3,a2
    80001ae0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	39a080e7          	jalr	922(ra) # 80000e7c <myproc>
  if(user_dst){
    80001aea:	c08d                	beqz	s1,80001b0c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001aec:	86d2                	mv	a3,s4
    80001aee:	864e                	mv	a2,s3
    80001af0:	85ca                	mv	a1,s2
    80001af2:	6928                	ld	a0,80(a0)
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	ff8080e7          	jalr	-8(ra) # 80000aec <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001afc:	70a2                	ld	ra,40(sp)
    80001afe:	7402                	ld	s0,32(sp)
    80001b00:	64e2                	ld	s1,24(sp)
    80001b02:	6942                	ld	s2,16(sp)
    80001b04:	69a2                	ld	s3,8(sp)
    80001b06:	6a02                	ld	s4,0(sp)
    80001b08:	6145                	addi	sp,sp,48
    80001b0a:	8082                	ret
    memmove((char *)dst, src, len);
    80001b0c:	000a061b          	sext.w	a2,s4
    80001b10:	85ce                	mv	a1,s3
    80001b12:	854a                	mv	a0,s2
    80001b14:	ffffe097          	auipc	ra,0xffffe
    80001b18:	6c4080e7          	jalr	1732(ra) # 800001d8 <memmove>
    return 0;
    80001b1c:	8526                	mv	a0,s1
    80001b1e:	bff9                	j	80001afc <either_copyout+0x32>

0000000080001b20 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b20:	7179                	addi	sp,sp,-48
    80001b22:	f406                	sd	ra,40(sp)
    80001b24:	f022                	sd	s0,32(sp)
    80001b26:	ec26                	sd	s1,24(sp)
    80001b28:	e84a                	sd	s2,16(sp)
    80001b2a:	e44e                	sd	s3,8(sp)
    80001b2c:	e052                	sd	s4,0(sp)
    80001b2e:	1800                	addi	s0,sp,48
    80001b30:	892a                	mv	s2,a0
    80001b32:	84ae                	mv	s1,a1
    80001b34:	89b2                	mv	s3,a2
    80001b36:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b38:	fffff097          	auipc	ra,0xfffff
    80001b3c:	344080e7          	jalr	836(ra) # 80000e7c <myproc>
  if(user_src){
    80001b40:	c08d                	beqz	s1,80001b62 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b42:	86d2                	mv	a3,s4
    80001b44:	864e                	mv	a2,s3
    80001b46:	85ca                	mv	a1,s2
    80001b48:	6928                	ld	a0,80(a0)
    80001b4a:	fffff097          	auipc	ra,0xfffff
    80001b4e:	02e080e7          	jalr	46(ra) # 80000b78 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b52:	70a2                	ld	ra,40(sp)
    80001b54:	7402                	ld	s0,32(sp)
    80001b56:	64e2                	ld	s1,24(sp)
    80001b58:	6942                	ld	s2,16(sp)
    80001b5a:	69a2                	ld	s3,8(sp)
    80001b5c:	6a02                	ld	s4,0(sp)
    80001b5e:	6145                	addi	sp,sp,48
    80001b60:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b62:	000a061b          	sext.w	a2,s4
    80001b66:	85ce                	mv	a1,s3
    80001b68:	854a                	mv	a0,s2
    80001b6a:	ffffe097          	auipc	ra,0xffffe
    80001b6e:	66e080e7          	jalr	1646(ra) # 800001d8 <memmove>
    return 0;
    80001b72:	8526                	mv	a0,s1
    80001b74:	bff9                	j	80001b52 <either_copyin+0x32>

0000000080001b76 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b76:	715d                	addi	sp,sp,-80
    80001b78:	e486                	sd	ra,72(sp)
    80001b7a:	e0a2                	sd	s0,64(sp)
    80001b7c:	fc26                	sd	s1,56(sp)
    80001b7e:	f84a                	sd	s2,48(sp)
    80001b80:	f44e                	sd	s3,40(sp)
    80001b82:	f052                	sd	s4,32(sp)
    80001b84:	ec56                	sd	s5,24(sp)
    80001b86:	e85a                	sd	s6,16(sp)
    80001b88:	e45e                	sd	s7,8(sp)
    80001b8a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b8c:	00006517          	auipc	a0,0x6
    80001b90:	4bc50513          	addi	a0,a0,1212 # 80008048 <etext+0x48>
    80001b94:	00004097          	auipc	ra,0x4
    80001b98:	78e080e7          	jalr	1934(ra) # 80006322 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b9c:	00008497          	auipc	s1,0x8
    80001ba0:	a3c48493          	addi	s1,s1,-1476 # 800095d8 <proc+0x158>
    80001ba4:	00015917          	auipc	s2,0x15
    80001ba8:	43490913          	addi	s2,s2,1076 # 80016fd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bac:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bae:	00006997          	auipc	s3,0x6
    80001bb2:	63a98993          	addi	s3,s3,1594 # 800081e8 <etext+0x1e8>
    printf("%d %s %s", p->pid, state, p->name);
    80001bb6:	00006a97          	auipc	s5,0x6
    80001bba:	63aa8a93          	addi	s5,s5,1594 # 800081f0 <etext+0x1f0>
    printf("\n");
    80001bbe:	00006a17          	auipc	s4,0x6
    80001bc2:	48aa0a13          	addi	s4,s4,1162 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bc6:	00006b97          	auipc	s7,0x6
    80001bca:	662b8b93          	addi	s7,s7,1634 # 80008228 <states.1800>
    80001bce:	a00d                	j	80001bf0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bd0:	ed86a583          	lw	a1,-296(a3)
    80001bd4:	8556                	mv	a0,s5
    80001bd6:	00004097          	auipc	ra,0x4
    80001bda:	74c080e7          	jalr	1868(ra) # 80006322 <printf>
    printf("\n");
    80001bde:	8552                	mv	a0,s4
    80001be0:	00004097          	auipc	ra,0x4
    80001be4:	742080e7          	jalr	1858(ra) # 80006322 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001be8:	36848493          	addi	s1,s1,872
    80001bec:	03248163          	beq	s1,s2,80001c0e <procdump+0x98>
    if(p->state == UNUSED)
    80001bf0:	86a6                	mv	a3,s1
    80001bf2:	ec04a783          	lw	a5,-320(s1)
    80001bf6:	dbed                	beqz	a5,80001be8 <procdump+0x72>
      state = "???";
    80001bf8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bfa:	fcfb6be3          	bltu	s6,a5,80001bd0 <procdump+0x5a>
    80001bfe:	1782                	slli	a5,a5,0x20
    80001c00:	9381                	srli	a5,a5,0x20
    80001c02:	078e                	slli	a5,a5,0x3
    80001c04:	97de                	add	a5,a5,s7
    80001c06:	6390                	ld	a2,0(a5)
    80001c08:	f661                	bnez	a2,80001bd0 <procdump+0x5a>
      state = "???";
    80001c0a:	864e                	mv	a2,s3
    80001c0c:	b7d1                	j	80001bd0 <procdump+0x5a>
  }
}
    80001c0e:	60a6                	ld	ra,72(sp)
    80001c10:	6406                	ld	s0,64(sp)
    80001c12:	74e2                	ld	s1,56(sp)
    80001c14:	7942                	ld	s2,48(sp)
    80001c16:	79a2                	ld	s3,40(sp)
    80001c18:	7a02                	ld	s4,32(sp)
    80001c1a:	6ae2                	ld	s5,24(sp)
    80001c1c:	6b42                	ld	s6,16(sp)
    80001c1e:	6ba2                	ld	s7,8(sp)
    80001c20:	6161                	addi	sp,sp,80
    80001c22:	8082                	ret

0000000080001c24 <swtch>:
    80001c24:	00153023          	sd	ra,0(a0)
    80001c28:	00253423          	sd	sp,8(a0)
    80001c2c:	e900                	sd	s0,16(a0)
    80001c2e:	ed04                	sd	s1,24(a0)
    80001c30:	03253023          	sd	s2,32(a0)
    80001c34:	03353423          	sd	s3,40(a0)
    80001c38:	03453823          	sd	s4,48(a0)
    80001c3c:	03553c23          	sd	s5,56(a0)
    80001c40:	05653023          	sd	s6,64(a0)
    80001c44:	05753423          	sd	s7,72(a0)
    80001c48:	05853823          	sd	s8,80(a0)
    80001c4c:	05953c23          	sd	s9,88(a0)
    80001c50:	07a53023          	sd	s10,96(a0)
    80001c54:	07b53423          	sd	s11,104(a0)
    80001c58:	0005b083          	ld	ra,0(a1)
    80001c5c:	0085b103          	ld	sp,8(a1)
    80001c60:	6980                	ld	s0,16(a1)
    80001c62:	6d84                	ld	s1,24(a1)
    80001c64:	0205b903          	ld	s2,32(a1)
    80001c68:	0285b983          	ld	s3,40(a1)
    80001c6c:	0305ba03          	ld	s4,48(a1)
    80001c70:	0385ba83          	ld	s5,56(a1)
    80001c74:	0405bb03          	ld	s6,64(a1)
    80001c78:	0485bb83          	ld	s7,72(a1)
    80001c7c:	0505bc03          	ld	s8,80(a1)
    80001c80:	0585bc83          	ld	s9,88(a1)
    80001c84:	0605bd03          	ld	s10,96(a1)
    80001c88:	0685bd83          	ld	s11,104(a1)
    80001c8c:	8082                	ret

0000000080001c8e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c8e:	1141                	addi	sp,sp,-16
    80001c90:	e406                	sd	ra,8(sp)
    80001c92:	e022                	sd	s0,0(sp)
    80001c94:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c96:	00006597          	auipc	a1,0x6
    80001c9a:	5c258593          	addi	a1,a1,1474 # 80008258 <states.1800+0x30>
    80001c9e:	00015517          	auipc	a0,0x15
    80001ca2:	1e250513          	addi	a0,a0,482 # 80016e80 <tickslock>
    80001ca6:	00005097          	auipc	ra,0x5
    80001caa:	aec080e7          	jalr	-1300(ra) # 80006792 <initlock>
}
    80001cae:	60a2                	ld	ra,8(sp)
    80001cb0:	6402                	ld	s0,0(sp)
    80001cb2:	0141                	addi	sp,sp,16
    80001cb4:	8082                	ret

0000000080001cb6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001cb6:	1141                	addi	sp,sp,-16
    80001cb8:	e422                	sd	s0,8(sp)
    80001cba:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cbc:	00004797          	auipc	a5,0x4
    80001cc0:	a2478793          	addi	a5,a5,-1500 # 800056e0 <kernelvec>
    80001cc4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cc8:	6422                	ld	s0,8(sp)
    80001cca:	0141                	addi	sp,sp,16
    80001ccc:	8082                	ret

0000000080001cce <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cce:	1141                	addi	sp,sp,-16
    80001cd0:	e406                	sd	ra,8(sp)
    80001cd2:	e022                	sd	s0,0(sp)
    80001cd4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	1a6080e7          	jalr	422(ra) # 80000e7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cde:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ce2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ce8:	00005617          	auipc	a2,0x5
    80001cec:	31860613          	addi	a2,a2,792 # 80007000 <_trampoline>
    80001cf0:	00005697          	auipc	a3,0x5
    80001cf4:	31068693          	addi	a3,a3,784 # 80007000 <_trampoline>
    80001cf8:	8e91                	sub	a3,a3,a2
    80001cfa:	040007b7          	lui	a5,0x4000
    80001cfe:	17fd                	addi	a5,a5,-1
    80001d00:	07b2                	slli	a5,a5,0xc
    80001d02:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d04:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d08:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d0a:	180026f3          	csrr	a3,satp
    80001d0e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d10:	6d38                	ld	a4,88(a0)
    80001d12:	6134                	ld	a3,64(a0)
    80001d14:	6585                	lui	a1,0x1
    80001d16:	96ae                	add	a3,a3,a1
    80001d18:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d1a:	6d38                	ld	a4,88(a0)
    80001d1c:	00000697          	auipc	a3,0x0
    80001d20:	13868693          	addi	a3,a3,312 # 80001e54 <usertrap>
    80001d24:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d26:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d28:	8692                	mv	a3,tp
    80001d2a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d30:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d34:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d38:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d3c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d3e:	6f18                	ld	a4,24(a4)
    80001d40:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d44:	692c                	ld	a1,80(a0)
    80001d46:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d48:	00005717          	auipc	a4,0x5
    80001d4c:	34870713          	addi	a4,a4,840 # 80007090 <userret>
    80001d50:	8f11                	sub	a4,a4,a2
    80001d52:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d54:	577d                	li	a4,-1
    80001d56:	177e                	slli	a4,a4,0x3f
    80001d58:	8dd9                	or	a1,a1,a4
    80001d5a:	02000537          	lui	a0,0x2000
    80001d5e:	157d                	addi	a0,a0,-1
    80001d60:	0536                	slli	a0,a0,0xd
    80001d62:	9782                	jalr	a5
}
    80001d64:	60a2                	ld	ra,8(sp)
    80001d66:	6402                	ld	s0,0(sp)
    80001d68:	0141                	addi	sp,sp,16
    80001d6a:	8082                	ret

0000000080001d6c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d6c:	1101                	addi	sp,sp,-32
    80001d6e:	ec06                	sd	ra,24(sp)
    80001d70:	e822                	sd	s0,16(sp)
    80001d72:	e426                	sd	s1,8(sp)
    80001d74:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d76:	00015497          	auipc	s1,0x15
    80001d7a:	10a48493          	addi	s1,s1,266 # 80016e80 <tickslock>
    80001d7e:	8526                	mv	a0,s1
    80001d80:	00005097          	auipc	ra,0x5
    80001d84:	aa2080e7          	jalr	-1374(ra) # 80006822 <acquire>
  ticks++;
    80001d88:	00007517          	auipc	a0,0x7
    80001d8c:	29050513          	addi	a0,a0,656 # 80009018 <ticks>
    80001d90:	411c                	lw	a5,0(a0)
    80001d92:	2785                	addiw	a5,a5,1
    80001d94:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d96:	00000097          	auipc	ra,0x0
    80001d9a:	972080e7          	jalr	-1678(ra) # 80001708 <wakeup>
  release(&tickslock);
    80001d9e:	8526                	mv	a0,s1
    80001da0:	00005097          	auipc	ra,0x5
    80001da4:	b36080e7          	jalr	-1226(ra) # 800068d6 <release>
}
    80001da8:	60e2                	ld	ra,24(sp)
    80001daa:	6442                	ld	s0,16(sp)
    80001dac:	64a2                	ld	s1,8(sp)
    80001dae:	6105                	addi	sp,sp,32
    80001db0:	8082                	ret

0000000080001db2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001db2:	1101                	addi	sp,sp,-32
    80001db4:	ec06                	sd	ra,24(sp)
    80001db6:	e822                	sd	s0,16(sp)
    80001db8:	e426                	sd	s1,8(sp)
    80001dba:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dbc:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001dc0:	00074d63          	bltz	a4,80001dda <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001dc4:	57fd                	li	a5,-1
    80001dc6:	17fe                	slli	a5,a5,0x3f
    80001dc8:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001dca:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dcc:	06f70363          	beq	a4,a5,80001e32 <devintr+0x80>
  }
}
    80001dd0:	60e2                	ld	ra,24(sp)
    80001dd2:	6442                	ld	s0,16(sp)
    80001dd4:	64a2                	ld	s1,8(sp)
    80001dd6:	6105                	addi	sp,sp,32
    80001dd8:	8082                	ret
     (scause & 0xff) == 9){
    80001dda:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001dde:	46a5                	li	a3,9
    80001de0:	fed792e3          	bne	a5,a3,80001dc4 <devintr+0x12>
    int irq = plic_claim();
    80001de4:	00004097          	auipc	ra,0x4
    80001de8:	a04080e7          	jalr	-1532(ra) # 800057e8 <plic_claim>
    80001dec:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dee:	47a9                	li	a5,10
    80001df0:	02f50763          	beq	a0,a5,80001e1e <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001df4:	4785                	li	a5,1
    80001df6:	02f50963          	beq	a0,a5,80001e28 <devintr+0x76>
    return 1;
    80001dfa:	4505                	li	a0,1
    } else if(irq){
    80001dfc:	d8f1                	beqz	s1,80001dd0 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dfe:	85a6                	mv	a1,s1
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	46050513          	addi	a0,a0,1120 # 80008260 <states.1800+0x38>
    80001e08:	00004097          	auipc	ra,0x4
    80001e0c:	51a080e7          	jalr	1306(ra) # 80006322 <printf>
      plic_complete(irq);
    80001e10:	8526                	mv	a0,s1
    80001e12:	00004097          	auipc	ra,0x4
    80001e16:	9fa080e7          	jalr	-1542(ra) # 8000580c <plic_complete>
    return 1;
    80001e1a:	4505                	li	a0,1
    80001e1c:	bf55                	j	80001dd0 <devintr+0x1e>
      uartintr();
    80001e1e:	00005097          	auipc	ra,0x5
    80001e22:	924080e7          	jalr	-1756(ra) # 80006742 <uartintr>
    80001e26:	b7ed                	j	80001e10 <devintr+0x5e>
      virtio_disk_intr();
    80001e28:	00004097          	auipc	ra,0x4
    80001e2c:	ec4080e7          	jalr	-316(ra) # 80005cec <virtio_disk_intr>
    80001e30:	b7c5                	j	80001e10 <devintr+0x5e>
    if(cpuid() == 0){
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	01e080e7          	jalr	30(ra) # 80000e50 <cpuid>
    80001e3a:	c901                	beqz	a0,80001e4a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e3c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e40:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e42:	14479073          	csrw	sip,a5
    return 2;
    80001e46:	4509                	li	a0,2
    80001e48:	b761                	j	80001dd0 <devintr+0x1e>
      clockintr();
    80001e4a:	00000097          	auipc	ra,0x0
    80001e4e:	f22080e7          	jalr	-222(ra) # 80001d6c <clockintr>
    80001e52:	b7ed                	j	80001e3c <devintr+0x8a>

0000000080001e54 <usertrap>:
{
    80001e54:	7139                	addi	sp,sp,-64
    80001e56:	fc06                	sd	ra,56(sp)
    80001e58:	f822                	sd	s0,48(sp)
    80001e5a:	f426                	sd	s1,40(sp)
    80001e5c:	f04a                	sd	s2,32(sp)
    80001e5e:	ec4e                	sd	s3,24(sp)
    80001e60:	e852                	sd	s4,16(sp)
    80001e62:	e456                	sd	s5,8(sp)
    80001e64:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e66:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e6a:	1007f793          	andi	a5,a5,256
    80001e6e:	efb1                	bnez	a5,80001eca <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e70:	00004797          	auipc	a5,0x4
    80001e74:	87078793          	addi	a5,a5,-1936 # 800056e0 <kernelvec>
    80001e78:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e7c:	fffff097          	auipc	ra,0xfffff
    80001e80:	000080e7          	jalr	ra # 80000e7c <myproc>
    80001e84:	892a                	mv	s2,a0
  p->trapframe->epc = r_sepc();
    80001e86:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e88:	14102773          	csrr	a4,sepc
    80001e8c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e8e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e92:	47a1                	li	a5,8
    80001e94:	04f70363          	beq	a4,a5,80001eda <usertrap+0x86>
    80001e98:	14202773          	csrr	a4,scause
  } else if (r_scause() == 12 || r_scause() == 13
    80001e9c:	47b1                	li	a5,12
    80001e9e:	00f70c63          	beq	a4,a5,80001eb6 <usertrap+0x62>
    80001ea2:	14202773          	csrr	a4,scause
    80001ea6:	47b5                	li	a5,13
    80001ea8:	00f70763          	beq	a4,a5,80001eb6 <usertrap+0x62>
    80001eac:	14202773          	csrr	a4,scause
             || r_scause() == 15) { // 页错误类型检查
    80001eb0:	47bd                	li	a5,15
    80001eb2:	1ef71063          	bne	a4,a5,80002092 <usertrap+0x23e>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eb6:	143029f3          	csrr	s3,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80001eba:	77fd                	lui	a5,0xfffff
    80001ebc:	00f9f9b3          	and	s3,s3,a5
    for (i = 0; i < NVMA; ++i) {
    80001ec0:	16890793          	addi	a5,s2,360
    80001ec4:	4481                	li	s1,0
    80001ec6:	4641                	li	a2,16
    80001ec8:	a0b5                	j	80001f34 <usertrap+0xe0>
    panic("usertrap: not from user mode");
    80001eca:	00006517          	auipc	a0,0x6
    80001ece:	3b650513          	addi	a0,a0,950 # 80008280 <states.1800+0x58>
    80001ed2:	00004097          	auipc	ra,0x4
    80001ed6:	406080e7          	jalr	1030(ra) # 800062d8 <panic>
    if(p->killed)
    80001eda:	551c                	lw	a5,40(a0)
    80001edc:	e3a9                	bnez	a5,80001f1e <usertrap+0xca>
    p->trapframe->epc += 4;
    80001ede:	05893703          	ld	a4,88(s2)
    80001ee2:	6f1c                	ld	a5,24(a4)
    80001ee4:	0791                	addi	a5,a5,4
    80001ee6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eec:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ef0:	10079073          	csrw	sstatus,a5
    syscall();
    80001ef4:	00000097          	auipc	ra,0x0
    80001ef8:	3f8080e7          	jalr	1016(ra) # 800022ec <syscall>
  if(p->killed)
    80001efc:	02892783          	lw	a5,40(s2)
    80001f00:	1a079363          	bnez	a5,800020a6 <usertrap+0x252>
  usertrapret();
    80001f04:	00000097          	auipc	ra,0x0
    80001f08:	dca080e7          	jalr	-566(ra) # 80001cce <usertrapret>
}
    80001f0c:	70e2                	ld	ra,56(sp)
    80001f0e:	7442                	ld	s0,48(sp)
    80001f10:	74a2                	ld	s1,40(sp)
    80001f12:	7902                	ld	s2,32(sp)
    80001f14:	69e2                	ld	s3,24(sp)
    80001f16:	6a42                	ld	s4,16(sp)
    80001f18:	6aa2                	ld	s5,8(sp)
    80001f1a:	6121                	addi	sp,sp,64
    80001f1c:	8082                	ret
      exit(-1);
    80001f1e:	557d                	li	a0,-1
    80001f20:	00000097          	auipc	ra,0x0
    80001f24:	8b8080e7          	jalr	-1864(ra) # 800017d8 <exit>
    80001f28:	bf5d                	j	80001ede <usertrap+0x8a>
    for (i = 0; i < NVMA; ++i) {
    80001f2a:	2485                	addiw	s1,s1,1
    80001f2c:	02078793          	addi	a5,a5,32 # fffffffffffff020 <end+0xffffffff7ffd0de0>
    80001f30:	10c48263          	beq	s1,a2,80002034 <usertrap+0x1e0>
      if (p->vma[i].addr && va >= p->vma[i].addr
    80001f34:	6398                	ld	a4,0(a5)
    80001f36:	db75                	beqz	a4,80001f2a <usertrap+0xd6>
    80001f38:	fee9e9e3          	bltu	s3,a4,80001f2a <usertrap+0xd6>
          && va < p->vma[i].addr + p->vma[i].len) {
    80001f3c:	4794                	lw	a3,8(a5)
    80001f3e:	9736                	add	a4,a4,a3
    80001f40:	fee9f5e3          	bgeu	s3,a4,80001f2a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f44:	14202773          	csrr	a4,scause
    if (r_scause() == 15 && (vma->prot & PROT_WRITE)
    80001f48:	47bd                	li	a5,15
    80001f4a:	00f71963          	bne	a4,a5,80001f5c <usertrap+0x108>
    80001f4e:	00b48793          	addi	a5,s1,11
    80001f52:	0796                	slli	a5,a5,0x5
    80001f54:	97ca                	add	a5,a5,s2
    80001f56:	4bdc                	lw	a5,20(a5)
    80001f58:	8b89                	andi	a5,a5,2
    80001f5a:	e7c5                	bnez	a5,80002002 <usertrap+0x1ae>
      if ((pa = kalloc()) == 0) {
    80001f5c:	ffffe097          	auipc	ra,0xffffe
    80001f60:	1bc080e7          	jalr	444(ra) # 80000118 <kalloc>
    80001f64:	8a2a                	mv	s4,a0
    80001f66:	c579                	beqz	a0,80002034 <usertrap+0x1e0>
      memset(pa, 0, PGSIZE);
    80001f68:	6605                	lui	a2,0x1
    80001f6a:	4581                	li	a1,0
    80001f6c:	ffffe097          	auipc	ra,0xffffe
    80001f70:	20c080e7          	jalr	524(ra) # 80000178 <memset>
      ilock(vma->f->ip);
    80001f74:	00549a93          	slli	s5,s1,0x5
    80001f78:	9aca                	add	s5,s5,s2
    80001f7a:	180ab783          	ld	a5,384(s5)
    80001f7e:	6f88                	ld	a0,24(a5)
    80001f80:	00001097          	auipc	ra,0x1
    80001f84:	e6a080e7          	jalr	-406(ra) # 80002dea <ilock>
      if (readi(vma->f->ip, 0, (uint64) pa, va - vma->addr + vma->offset, PGSIZE) < 0) {
    80001f88:	17caa783          	lw	a5,380(s5)
    80001f8c:	013787bb          	addw	a5,a5,s3
    80001f90:	168ab683          	ld	a3,360(s5)
    80001f94:	180ab503          	ld	a0,384(s5)
    80001f98:	6705                	lui	a4,0x1
    80001f9a:	40d786bb          	subw	a3,a5,a3
    80001f9e:	8652                	mv	a2,s4
    80001fa0:	4581                	li	a1,0
    80001fa2:	6d08                	ld	a0,24(a0)
    80001fa4:	00001097          	auipc	ra,0x1
    80001fa8:	0fa080e7          	jalr	250(ra) # 8000309e <readi>
    80001fac:	06054d63          	bltz	a0,80002026 <usertrap+0x1d2>
      iunlock(vma->f->ip);
    80001fb0:	0496                	slli	s1,s1,0x5
    80001fb2:	94ca                	add	s1,s1,s2
    80001fb4:	1804b783          	ld	a5,384(s1)
    80001fb8:	6f88                	ld	a0,24(a5)
    80001fba:	00001097          	auipc	ra,0x1
    80001fbe:	ef2080e7          	jalr	-270(ra) # 80002eac <iunlock>
      if ((vma->prot & PROT_READ)) {
    80001fc2:	174aa783          	lw	a5,372(s5)
    80001fc6:	0017f693          	andi	a3,a5,1
    int flags = PTE_U;
    80001fca:	4741                	li	a4,16
      if ((vma->prot & PROT_READ)) {
    80001fcc:	c291                	beqz	a3,80001fd0 <usertrap+0x17c>
        flags |= PTE_R;
    80001fce:	4749                	li	a4,18
    80001fd0:	14202673          	csrr	a2,scause
      if (r_scause() == 15 && (vma->prot & PROT_WRITE)) {
    80001fd4:	46bd                	li	a3,15
    80001fd6:	0ad60863          	beq	a2,a3,80002086 <usertrap+0x232>
      if ((vma->prot & PROT_EXEC)) {
    80001fda:	8b91                	andi	a5,a5,4
    80001fdc:	c399                	beqz	a5,80001fe2 <usertrap+0x18e>
        flags |= PTE_X;
    80001fde:	00876713          	ori	a4,a4,8
      if (mappages(p->pagetable, va, PGSIZE, (uint64) pa, flags) != 0) {
    80001fe2:	86d2                	mv	a3,s4
    80001fe4:	6605                	lui	a2,0x1
    80001fe6:	85ce                	mv	a1,s3
    80001fe8:	05093503          	ld	a0,80(s2)
    80001fec:	ffffe097          	auipc	ra,0xffffe
    80001ff0:	55c080e7          	jalr	1372(ra) # 80000548 <mappages>
    80001ff4:	d501                	beqz	a0,80001efc <usertrap+0xa8>
        kfree(pa);
    80001ff6:	8552                	mv	a0,s4
    80001ff8:	ffffe097          	auipc	ra,0xffffe
    80001ffc:	024080e7          	jalr	36(ra) # 8000001c <kfree>
        goto err;
    80002000:	a815                	j	80002034 <usertrap+0x1e0>
        && walkaddr(p->pagetable, va)) {
    80002002:	85ce                	mv	a1,s3
    80002004:	05093503          	ld	a0,80(s2)
    80002008:	ffffe097          	auipc	ra,0xffffe
    8000200c:	4fe080e7          	jalr	1278(ra) # 80000506 <walkaddr>
    80002010:	d531                	beqz	a0,80001f5c <usertrap+0x108>
      if (uvmsetdirtywrite(p->pagetable, va)) {
    80002012:	85ce                	mv	a1,s3
    80002014:	05093503          	ld	a0,80(s2)
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	cc8080e7          	jalr	-824(ra) # 80000ce0 <uvmsetdirtywrite>
    80002020:	ec050ee3          	beqz	a0,80001efc <usertrap+0xa8>
    80002024:	a801                	j	80002034 <usertrap+0x1e0>
        iunlock(vma->f->ip);
    80002026:	180ab783          	ld	a5,384(s5)
    8000202a:	6f88                	ld	a0,24(a5)
    8000202c:	00001097          	auipc	ra,0x1
    80002030:	e80080e7          	jalr	-384(ra) # 80002eac <iunlock>
    80002034:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002038:	03092603          	lw	a2,48(s2)
    8000203c:	00006517          	auipc	a0,0x6
    80002040:	26450513          	addi	a0,a0,612 # 800082a0 <states.1800+0x78>
    80002044:	00004097          	auipc	ra,0x4
    80002048:	2de080e7          	jalr	734(ra) # 80006322 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000204c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002050:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002054:	00006517          	auipc	a0,0x6
    80002058:	27c50513          	addi	a0,a0,636 # 800082d0 <states.1800+0xa8>
    8000205c:	00004097          	auipc	ra,0x4
    80002060:	2c6080e7          	jalr	710(ra) # 80006322 <printf>
    p->killed = 1;
    80002064:	4785                	li	a5,1
    80002066:	02f92423          	sw	a5,40(s2)
    8000206a:	4481                	li	s1,0
    exit(-1);
    8000206c:	557d                	li	a0,-1
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	76a080e7          	jalr	1898(ra) # 800017d8 <exit>
  if(which_dev == 2)
    80002076:	4789                	li	a5,2
    80002078:	e8f496e3          	bne	s1,a5,80001f04 <usertrap+0xb0>
    yield();
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	4c4080e7          	jalr	1220(ra) # 80001540 <yield>
    80002084:	b541                	j	80001f04 <usertrap+0xb0>
      if (r_scause() == 15 && (vma->prot & PROT_WRITE)) {
    80002086:	0027f693          	andi	a3,a5,2
    8000208a:	daa1                	beqz	a3,80001fda <usertrap+0x186>
        flags |= PTE_W | PTE_D;
    8000208c:	08476713          	ori	a4,a4,132
    80002090:	b7a9                	j	80001fda <usertrap+0x186>
  else if((which_dev = devintr()) != 0){
    80002092:	00000097          	auipc	ra,0x0
    80002096:	d20080e7          	jalr	-736(ra) # 80001db2 <devintr>
    8000209a:	84aa                	mv	s1,a0
    8000209c:	dd41                	beqz	a0,80002034 <usertrap+0x1e0>
  if(p->killed)
    8000209e:	02892783          	lw	a5,40(s2)
    800020a2:	dbf1                	beqz	a5,80002076 <usertrap+0x222>
    800020a4:	b7e1                	j	8000206c <usertrap+0x218>
    800020a6:	4481                	li	s1,0
    800020a8:	b7d1                	j	8000206c <usertrap+0x218>

00000000800020aa <kerneltrap>:
{
    800020aa:	7179                	addi	sp,sp,-48
    800020ac:	f406                	sd	ra,40(sp)
    800020ae:	f022                	sd	s0,32(sp)
    800020b0:	ec26                	sd	s1,24(sp)
    800020b2:	e84a                	sd	s2,16(sp)
    800020b4:	e44e                	sd	s3,8(sp)
    800020b6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020b8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020bc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800020c0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800020c4:	1004f793          	andi	a5,s1,256
    800020c8:	cb85                	beqz	a5,800020f8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020ca:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020ce:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800020d0:	ef85                	bnez	a5,80002108 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800020d2:	00000097          	auipc	ra,0x0
    800020d6:	ce0080e7          	jalr	-800(ra) # 80001db2 <devintr>
    800020da:	cd1d                	beqz	a0,80002118 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020dc:	4789                	li	a5,2
    800020de:	06f50a63          	beq	a0,a5,80002152 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800020e2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020e6:	10049073          	csrw	sstatus,s1
}
    800020ea:	70a2                	ld	ra,40(sp)
    800020ec:	7402                	ld	s0,32(sp)
    800020ee:	64e2                	ld	s1,24(sp)
    800020f0:	6942                	ld	s2,16(sp)
    800020f2:	69a2                	ld	s3,8(sp)
    800020f4:	6145                	addi	sp,sp,48
    800020f6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800020f8:	00006517          	auipc	a0,0x6
    800020fc:	1f850513          	addi	a0,a0,504 # 800082f0 <states.1800+0xc8>
    80002100:	00004097          	auipc	ra,0x4
    80002104:	1d8080e7          	jalr	472(ra) # 800062d8 <panic>
    panic("kerneltrap: interrupts enabled");
    80002108:	00006517          	auipc	a0,0x6
    8000210c:	21050513          	addi	a0,a0,528 # 80008318 <states.1800+0xf0>
    80002110:	00004097          	auipc	ra,0x4
    80002114:	1c8080e7          	jalr	456(ra) # 800062d8 <panic>
    printf("scause %p\n", scause);
    80002118:	85ce                	mv	a1,s3
    8000211a:	00006517          	auipc	a0,0x6
    8000211e:	21e50513          	addi	a0,a0,542 # 80008338 <states.1800+0x110>
    80002122:	00004097          	auipc	ra,0x4
    80002126:	200080e7          	jalr	512(ra) # 80006322 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000212a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000212e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002132:	00006517          	auipc	a0,0x6
    80002136:	21650513          	addi	a0,a0,534 # 80008348 <states.1800+0x120>
    8000213a:	00004097          	auipc	ra,0x4
    8000213e:	1e8080e7          	jalr	488(ra) # 80006322 <printf>
    panic("kerneltrap");
    80002142:	00006517          	auipc	a0,0x6
    80002146:	21e50513          	addi	a0,a0,542 # 80008360 <states.1800+0x138>
    8000214a:	00004097          	auipc	ra,0x4
    8000214e:	18e080e7          	jalr	398(ra) # 800062d8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	d2a080e7          	jalr	-726(ra) # 80000e7c <myproc>
    8000215a:	d541                	beqz	a0,800020e2 <kerneltrap+0x38>
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	d20080e7          	jalr	-736(ra) # 80000e7c <myproc>
    80002164:	4d18                	lw	a4,24(a0)
    80002166:	4791                	li	a5,4
    80002168:	f6f71de3          	bne	a4,a5,800020e2 <kerneltrap+0x38>
    yield();
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	3d4080e7          	jalr	980(ra) # 80001540 <yield>
    80002174:	b7bd                	j	800020e2 <kerneltrap+0x38>

0000000080002176 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002176:	1101                	addi	sp,sp,-32
    80002178:	ec06                	sd	ra,24(sp)
    8000217a:	e822                	sd	s0,16(sp)
    8000217c:	e426                	sd	s1,8(sp)
    8000217e:	1000                	addi	s0,sp,32
    80002180:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	cfa080e7          	jalr	-774(ra) # 80000e7c <myproc>
  switch (n) {
    8000218a:	4795                	li	a5,5
    8000218c:	0497e163          	bltu	a5,s1,800021ce <argraw+0x58>
    80002190:	048a                	slli	s1,s1,0x2
    80002192:	00006717          	auipc	a4,0x6
    80002196:	20670713          	addi	a4,a4,518 # 80008398 <states.1800+0x170>
    8000219a:	94ba                	add	s1,s1,a4
    8000219c:	409c                	lw	a5,0(s1)
    8000219e:	97ba                	add	a5,a5,a4
    800021a0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800021a2:	6d3c                	ld	a5,88(a0)
    800021a4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800021a6:	60e2                	ld	ra,24(sp)
    800021a8:	6442                	ld	s0,16(sp)
    800021aa:	64a2                	ld	s1,8(sp)
    800021ac:	6105                	addi	sp,sp,32
    800021ae:	8082                	ret
    return p->trapframe->a1;
    800021b0:	6d3c                	ld	a5,88(a0)
    800021b2:	7fa8                	ld	a0,120(a5)
    800021b4:	bfcd                	j	800021a6 <argraw+0x30>
    return p->trapframe->a2;
    800021b6:	6d3c                	ld	a5,88(a0)
    800021b8:	63c8                	ld	a0,128(a5)
    800021ba:	b7f5                	j	800021a6 <argraw+0x30>
    return p->trapframe->a3;
    800021bc:	6d3c                	ld	a5,88(a0)
    800021be:	67c8                	ld	a0,136(a5)
    800021c0:	b7dd                	j	800021a6 <argraw+0x30>
    return p->trapframe->a4;
    800021c2:	6d3c                	ld	a5,88(a0)
    800021c4:	6bc8                	ld	a0,144(a5)
    800021c6:	b7c5                	j	800021a6 <argraw+0x30>
    return p->trapframe->a5;
    800021c8:	6d3c                	ld	a5,88(a0)
    800021ca:	6fc8                	ld	a0,152(a5)
    800021cc:	bfe9                	j	800021a6 <argraw+0x30>
  panic("argraw");
    800021ce:	00006517          	auipc	a0,0x6
    800021d2:	1a250513          	addi	a0,a0,418 # 80008370 <states.1800+0x148>
    800021d6:	00004097          	auipc	ra,0x4
    800021da:	102080e7          	jalr	258(ra) # 800062d8 <panic>

00000000800021de <fetchaddr>:
{
    800021de:	1101                	addi	sp,sp,-32
    800021e0:	ec06                	sd	ra,24(sp)
    800021e2:	e822                	sd	s0,16(sp)
    800021e4:	e426                	sd	s1,8(sp)
    800021e6:	e04a                	sd	s2,0(sp)
    800021e8:	1000                	addi	s0,sp,32
    800021ea:	84aa                	mv	s1,a0
    800021ec:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	c8e080e7          	jalr	-882(ra) # 80000e7c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800021f6:	653c                	ld	a5,72(a0)
    800021f8:	02f4f863          	bgeu	s1,a5,80002228 <fetchaddr+0x4a>
    800021fc:	00848713          	addi	a4,s1,8
    80002200:	02e7e663          	bltu	a5,a4,8000222c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002204:	46a1                	li	a3,8
    80002206:	8626                	mv	a2,s1
    80002208:	85ca                	mv	a1,s2
    8000220a:	6928                	ld	a0,80(a0)
    8000220c:	fffff097          	auipc	ra,0xfffff
    80002210:	96c080e7          	jalr	-1684(ra) # 80000b78 <copyin>
    80002214:	00a03533          	snez	a0,a0
    80002218:	40a00533          	neg	a0,a0
}
    8000221c:	60e2                	ld	ra,24(sp)
    8000221e:	6442                	ld	s0,16(sp)
    80002220:	64a2                	ld	s1,8(sp)
    80002222:	6902                	ld	s2,0(sp)
    80002224:	6105                	addi	sp,sp,32
    80002226:	8082                	ret
    return -1;
    80002228:	557d                	li	a0,-1
    8000222a:	bfcd                	j	8000221c <fetchaddr+0x3e>
    8000222c:	557d                	li	a0,-1
    8000222e:	b7fd                	j	8000221c <fetchaddr+0x3e>

0000000080002230 <fetchstr>:
{
    80002230:	7179                	addi	sp,sp,-48
    80002232:	f406                	sd	ra,40(sp)
    80002234:	f022                	sd	s0,32(sp)
    80002236:	ec26                	sd	s1,24(sp)
    80002238:	e84a                	sd	s2,16(sp)
    8000223a:	e44e                	sd	s3,8(sp)
    8000223c:	1800                	addi	s0,sp,48
    8000223e:	892a                	mv	s2,a0
    80002240:	84ae                	mv	s1,a1
    80002242:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	c38080e7          	jalr	-968(ra) # 80000e7c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000224c:	86ce                	mv	a3,s3
    8000224e:	864a                	mv	a2,s2
    80002250:	85a6                	mv	a1,s1
    80002252:	6928                	ld	a0,80(a0)
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	9b0080e7          	jalr	-1616(ra) # 80000c04 <copyinstr>
  if(err < 0)
    8000225c:	00054763          	bltz	a0,8000226a <fetchstr+0x3a>
  return strlen(buf);
    80002260:	8526                	mv	a0,s1
    80002262:	ffffe097          	auipc	ra,0xffffe
    80002266:	09a080e7          	jalr	154(ra) # 800002fc <strlen>
}
    8000226a:	70a2                	ld	ra,40(sp)
    8000226c:	7402                	ld	s0,32(sp)
    8000226e:	64e2                	ld	s1,24(sp)
    80002270:	6942                	ld	s2,16(sp)
    80002272:	69a2                	ld	s3,8(sp)
    80002274:	6145                	addi	sp,sp,48
    80002276:	8082                	ret

0000000080002278 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002278:	1101                	addi	sp,sp,-32
    8000227a:	ec06                	sd	ra,24(sp)
    8000227c:	e822                	sd	s0,16(sp)
    8000227e:	e426                	sd	s1,8(sp)
    80002280:	1000                	addi	s0,sp,32
    80002282:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002284:	00000097          	auipc	ra,0x0
    80002288:	ef2080e7          	jalr	-270(ra) # 80002176 <argraw>
    8000228c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000228e:	4501                	li	a0,0
    80002290:	60e2                	ld	ra,24(sp)
    80002292:	6442                	ld	s0,16(sp)
    80002294:	64a2                	ld	s1,8(sp)
    80002296:	6105                	addi	sp,sp,32
    80002298:	8082                	ret

000000008000229a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000229a:	1101                	addi	sp,sp,-32
    8000229c:	ec06                	sd	ra,24(sp)
    8000229e:	e822                	sd	s0,16(sp)
    800022a0:	e426                	sd	s1,8(sp)
    800022a2:	1000                	addi	s0,sp,32
    800022a4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800022a6:	00000097          	auipc	ra,0x0
    800022aa:	ed0080e7          	jalr	-304(ra) # 80002176 <argraw>
    800022ae:	e088                	sd	a0,0(s1)
  return 0;
}
    800022b0:	4501                	li	a0,0
    800022b2:	60e2                	ld	ra,24(sp)
    800022b4:	6442                	ld	s0,16(sp)
    800022b6:	64a2                	ld	s1,8(sp)
    800022b8:	6105                	addi	sp,sp,32
    800022ba:	8082                	ret

00000000800022bc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800022bc:	1101                	addi	sp,sp,-32
    800022be:	ec06                	sd	ra,24(sp)
    800022c0:	e822                	sd	s0,16(sp)
    800022c2:	e426                	sd	s1,8(sp)
    800022c4:	e04a                	sd	s2,0(sp)
    800022c6:	1000                	addi	s0,sp,32
    800022c8:	84ae                	mv	s1,a1
    800022ca:	8932                	mv	s2,a2
  *ip = argraw(n);
    800022cc:	00000097          	auipc	ra,0x0
    800022d0:	eaa080e7          	jalr	-342(ra) # 80002176 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800022d4:	864a                	mv	a2,s2
    800022d6:	85a6                	mv	a1,s1
    800022d8:	00000097          	auipc	ra,0x0
    800022dc:	f58080e7          	jalr	-168(ra) # 80002230 <fetchstr>
}
    800022e0:	60e2                	ld	ra,24(sp)
    800022e2:	6442                	ld	s0,16(sp)
    800022e4:	64a2                	ld	s1,8(sp)
    800022e6:	6902                	ld	s2,0(sp)
    800022e8:	6105                	addi	sp,sp,32
    800022ea:	8082                	ret

00000000800022ec <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    800022ec:	1101                	addi	sp,sp,-32
    800022ee:	ec06                	sd	ra,24(sp)
    800022f0:	e822                	sd	s0,16(sp)
    800022f2:	e426                	sd	s1,8(sp)
    800022f4:	e04a                	sd	s2,0(sp)
    800022f6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	b84080e7          	jalr	-1148(ra) # 80000e7c <myproc>
    80002300:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002302:	05853903          	ld	s2,88(a0)
    80002306:	0a893783          	ld	a5,168(s2)
    8000230a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000230e:	37fd                	addiw	a5,a5,-1
    80002310:	4759                	li	a4,22
    80002312:	00f76f63          	bltu	a4,a5,80002330 <syscall+0x44>
    80002316:	00369713          	slli	a4,a3,0x3
    8000231a:	00006797          	auipc	a5,0x6
    8000231e:	09678793          	addi	a5,a5,150 # 800083b0 <syscalls>
    80002322:	97ba                	add	a5,a5,a4
    80002324:	639c                	ld	a5,0(a5)
    80002326:	c789                	beqz	a5,80002330 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002328:	9782                	jalr	a5
    8000232a:	06a93823          	sd	a0,112(s2)
    8000232e:	a839                	j	8000234c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002330:	15848613          	addi	a2,s1,344
    80002334:	588c                	lw	a1,48(s1)
    80002336:	00006517          	auipc	a0,0x6
    8000233a:	04250513          	addi	a0,a0,66 # 80008378 <states.1800+0x150>
    8000233e:	00004097          	auipc	ra,0x4
    80002342:	fe4080e7          	jalr	-28(ra) # 80006322 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002346:	6cbc                	ld	a5,88(s1)
    80002348:	577d                	li	a4,-1
    8000234a:	fbb8                	sd	a4,112(a5)
  }
}
    8000234c:	60e2                	ld	ra,24(sp)
    8000234e:	6442                	ld	s0,16(sp)
    80002350:	64a2                	ld	s1,8(sp)
    80002352:	6902                	ld	s2,0(sp)
    80002354:	6105                	addi	sp,sp,32
    80002356:	8082                	ret

0000000080002358 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002358:	1101                	addi	sp,sp,-32
    8000235a:	ec06                	sd	ra,24(sp)
    8000235c:	e822                	sd	s0,16(sp)
    8000235e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002360:	fec40593          	addi	a1,s0,-20
    80002364:	4501                	li	a0,0
    80002366:	00000097          	auipc	ra,0x0
    8000236a:	f12080e7          	jalr	-238(ra) # 80002278 <argint>
    return -1;
    8000236e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002370:	00054963          	bltz	a0,80002382 <sys_exit+0x2a>
  exit(n);
    80002374:	fec42503          	lw	a0,-20(s0)
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	460080e7          	jalr	1120(ra) # 800017d8 <exit>
  return 0;  // not reached
    80002380:	4781                	li	a5,0
}
    80002382:	853e                	mv	a0,a5
    80002384:	60e2                	ld	ra,24(sp)
    80002386:	6442                	ld	s0,16(sp)
    80002388:	6105                	addi	sp,sp,32
    8000238a:	8082                	ret

000000008000238c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000238c:	1141                	addi	sp,sp,-16
    8000238e:	e406                	sd	ra,8(sp)
    80002390:	e022                	sd	s0,0(sp)
    80002392:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002394:	fffff097          	auipc	ra,0xfffff
    80002398:	ae8080e7          	jalr	-1304(ra) # 80000e7c <myproc>
}
    8000239c:	5908                	lw	a0,48(a0)
    8000239e:	60a2                	ld	ra,8(sp)
    800023a0:	6402                	ld	s0,0(sp)
    800023a2:	0141                	addi	sp,sp,16
    800023a4:	8082                	ret

00000000800023a6 <sys_fork>:

uint64
sys_fork(void)
{
    800023a6:	1141                	addi	sp,sp,-16
    800023a8:	e406                	sd	ra,8(sp)
    800023aa:	e022                	sd	s0,0(sp)
    800023ac:	0800                	addi	s0,sp,16
  return fork();
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	e9c080e7          	jalr	-356(ra) # 8000124a <fork>
}
    800023b6:	60a2                	ld	ra,8(sp)
    800023b8:	6402                	ld	s0,0(sp)
    800023ba:	0141                	addi	sp,sp,16
    800023bc:	8082                	ret

00000000800023be <sys_wait>:

uint64
sys_wait(void)
{
    800023be:	1101                	addi	sp,sp,-32
    800023c0:	ec06                	sd	ra,24(sp)
    800023c2:	e822                	sd	s0,16(sp)
    800023c4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800023c6:	fe840593          	addi	a1,s0,-24
    800023ca:	4501                	li	a0,0
    800023cc:	00000097          	auipc	ra,0x0
    800023d0:	ece080e7          	jalr	-306(ra) # 8000229a <argaddr>
    800023d4:	87aa                	mv	a5,a0
    return -1;
    800023d6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800023d8:	0007c863          	bltz	a5,800023e8 <sys_wait+0x2a>
  return wait(p);
    800023dc:	fe843503          	ld	a0,-24(s0)
    800023e0:	fffff097          	auipc	ra,0xfffff
    800023e4:	200080e7          	jalr	512(ra) # 800015e0 <wait>
}
    800023e8:	60e2                	ld	ra,24(sp)
    800023ea:	6442                	ld	s0,16(sp)
    800023ec:	6105                	addi	sp,sp,32
    800023ee:	8082                	ret

00000000800023f0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800023f0:	7179                	addi	sp,sp,-48
    800023f2:	f406                	sd	ra,40(sp)
    800023f4:	f022                	sd	s0,32(sp)
    800023f6:	ec26                	sd	s1,24(sp)
    800023f8:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800023fa:	fdc40593          	addi	a1,s0,-36
    800023fe:	4501                	li	a0,0
    80002400:	00000097          	auipc	ra,0x0
    80002404:	e78080e7          	jalr	-392(ra) # 80002278 <argint>
    80002408:	87aa                	mv	a5,a0
    return -1;
    8000240a:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000240c:	0207c063          	bltz	a5,8000242c <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002410:	fffff097          	auipc	ra,0xfffff
    80002414:	a6c080e7          	jalr	-1428(ra) # 80000e7c <myproc>
    80002418:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000241a:	fdc42503          	lw	a0,-36(s0)
    8000241e:	fffff097          	auipc	ra,0xfffff
    80002422:	db8080e7          	jalr	-584(ra) # 800011d6 <growproc>
    80002426:	00054863          	bltz	a0,80002436 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000242a:	8526                	mv	a0,s1
}
    8000242c:	70a2                	ld	ra,40(sp)
    8000242e:	7402                	ld	s0,32(sp)
    80002430:	64e2                	ld	s1,24(sp)
    80002432:	6145                	addi	sp,sp,48
    80002434:	8082                	ret
    return -1;
    80002436:	557d                	li	a0,-1
    80002438:	bfd5                	j	8000242c <sys_sbrk+0x3c>

000000008000243a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000243a:	7139                	addi	sp,sp,-64
    8000243c:	fc06                	sd	ra,56(sp)
    8000243e:	f822                	sd	s0,48(sp)
    80002440:	f426                	sd	s1,40(sp)
    80002442:	f04a                	sd	s2,32(sp)
    80002444:	ec4e                	sd	s3,24(sp)
    80002446:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002448:	fcc40593          	addi	a1,s0,-52
    8000244c:	4501                	li	a0,0
    8000244e:	00000097          	auipc	ra,0x0
    80002452:	e2a080e7          	jalr	-470(ra) # 80002278 <argint>
    return -1;
    80002456:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002458:	06054563          	bltz	a0,800024c2 <sys_sleep+0x88>
  acquire(&tickslock);
    8000245c:	00015517          	auipc	a0,0x15
    80002460:	a2450513          	addi	a0,a0,-1500 # 80016e80 <tickslock>
    80002464:	00004097          	auipc	ra,0x4
    80002468:	3be080e7          	jalr	958(ra) # 80006822 <acquire>
  ticks0 = ticks;
    8000246c:	00007917          	auipc	s2,0x7
    80002470:	bac92903          	lw	s2,-1108(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002474:	fcc42783          	lw	a5,-52(s0)
    80002478:	cf85                	beqz	a5,800024b0 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000247a:	00015997          	auipc	s3,0x15
    8000247e:	a0698993          	addi	s3,s3,-1530 # 80016e80 <tickslock>
    80002482:	00007497          	auipc	s1,0x7
    80002486:	b9648493          	addi	s1,s1,-1130 # 80009018 <ticks>
    if(myproc()->killed){
    8000248a:	fffff097          	auipc	ra,0xfffff
    8000248e:	9f2080e7          	jalr	-1550(ra) # 80000e7c <myproc>
    80002492:	551c                	lw	a5,40(a0)
    80002494:	ef9d                	bnez	a5,800024d2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002496:	85ce                	mv	a1,s3
    80002498:	8526                	mv	a0,s1
    8000249a:	fffff097          	auipc	ra,0xfffff
    8000249e:	0e2080e7          	jalr	226(ra) # 8000157c <sleep>
  while(ticks - ticks0 < n){
    800024a2:	409c                	lw	a5,0(s1)
    800024a4:	412787bb          	subw	a5,a5,s2
    800024a8:	fcc42703          	lw	a4,-52(s0)
    800024ac:	fce7efe3          	bltu	a5,a4,8000248a <sys_sleep+0x50>
  }
  release(&tickslock);
    800024b0:	00015517          	auipc	a0,0x15
    800024b4:	9d050513          	addi	a0,a0,-1584 # 80016e80 <tickslock>
    800024b8:	00004097          	auipc	ra,0x4
    800024bc:	41e080e7          	jalr	1054(ra) # 800068d6 <release>
  return 0;
    800024c0:	4781                	li	a5,0
}
    800024c2:	853e                	mv	a0,a5
    800024c4:	70e2                	ld	ra,56(sp)
    800024c6:	7442                	ld	s0,48(sp)
    800024c8:	74a2                	ld	s1,40(sp)
    800024ca:	7902                	ld	s2,32(sp)
    800024cc:	69e2                	ld	s3,24(sp)
    800024ce:	6121                	addi	sp,sp,64
    800024d0:	8082                	ret
      release(&tickslock);
    800024d2:	00015517          	auipc	a0,0x15
    800024d6:	9ae50513          	addi	a0,a0,-1618 # 80016e80 <tickslock>
    800024da:	00004097          	auipc	ra,0x4
    800024de:	3fc080e7          	jalr	1020(ra) # 800068d6 <release>
      return -1;
    800024e2:	57fd                	li	a5,-1
    800024e4:	bff9                	j	800024c2 <sys_sleep+0x88>

00000000800024e6 <sys_kill>:

uint64
sys_kill(void)
{
    800024e6:	1101                	addi	sp,sp,-32
    800024e8:	ec06                	sd	ra,24(sp)
    800024ea:	e822                	sd	s0,16(sp)
    800024ec:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800024ee:	fec40593          	addi	a1,s0,-20
    800024f2:	4501                	li	a0,0
    800024f4:	00000097          	auipc	ra,0x0
    800024f8:	d84080e7          	jalr	-636(ra) # 80002278 <argint>
    800024fc:	87aa                	mv	a5,a0
    return -1;
    800024fe:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002500:	0007c863          	bltz	a5,80002510 <sys_kill+0x2a>
  return kill(pid);
    80002504:	fec42503          	lw	a0,-20(s0)
    80002508:	fffff097          	auipc	ra,0xfffff
    8000250c:	550080e7          	jalr	1360(ra) # 80001a58 <kill>
}
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	6105                	addi	sp,sp,32
    80002516:	8082                	ret

0000000080002518 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002518:	1101                	addi	sp,sp,-32
    8000251a:	ec06                	sd	ra,24(sp)
    8000251c:	e822                	sd	s0,16(sp)
    8000251e:	e426                	sd	s1,8(sp)
    80002520:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002522:	00015517          	auipc	a0,0x15
    80002526:	95e50513          	addi	a0,a0,-1698 # 80016e80 <tickslock>
    8000252a:	00004097          	auipc	ra,0x4
    8000252e:	2f8080e7          	jalr	760(ra) # 80006822 <acquire>
  xticks = ticks;
    80002532:	00007497          	auipc	s1,0x7
    80002536:	ae64a483          	lw	s1,-1306(s1) # 80009018 <ticks>
  release(&tickslock);
    8000253a:	00015517          	auipc	a0,0x15
    8000253e:	94650513          	addi	a0,a0,-1722 # 80016e80 <tickslock>
    80002542:	00004097          	auipc	ra,0x4
    80002546:	394080e7          	jalr	916(ra) # 800068d6 <release>
  return xticks;
}
    8000254a:	02049513          	slli	a0,s1,0x20
    8000254e:	9101                	srli	a0,a0,0x20
    80002550:	60e2                	ld	ra,24(sp)
    80002552:	6442                	ld	s0,16(sp)
    80002554:	64a2                	ld	s1,8(sp)
    80002556:	6105                	addi	sp,sp,32
    80002558:	8082                	ret

000000008000255a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000255a:	7179                	addi	sp,sp,-48
    8000255c:	f406                	sd	ra,40(sp)
    8000255e:	f022                	sd	s0,32(sp)
    80002560:	ec26                	sd	s1,24(sp)
    80002562:	e84a                	sd	s2,16(sp)
    80002564:	e44e                	sd	s3,8(sp)
    80002566:	e052                	sd	s4,0(sp)
    80002568:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000256a:	00006597          	auipc	a1,0x6
    8000256e:	f0658593          	addi	a1,a1,-250 # 80008470 <syscalls+0xc0>
    80002572:	00015517          	auipc	a0,0x15
    80002576:	92650513          	addi	a0,a0,-1754 # 80016e98 <bcache>
    8000257a:	00004097          	auipc	ra,0x4
    8000257e:	218080e7          	jalr	536(ra) # 80006792 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002582:	0001d797          	auipc	a5,0x1d
    80002586:	91678793          	addi	a5,a5,-1770 # 8001ee98 <bcache+0x8000>
    8000258a:	0001d717          	auipc	a4,0x1d
    8000258e:	b7670713          	addi	a4,a4,-1162 # 8001f100 <bcache+0x8268>
    80002592:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002596:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000259a:	00015497          	auipc	s1,0x15
    8000259e:	91648493          	addi	s1,s1,-1770 # 80016eb0 <bcache+0x18>
    b->next = bcache.head.next;
    800025a2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800025a4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800025a6:	00006a17          	auipc	s4,0x6
    800025aa:	ed2a0a13          	addi	s4,s4,-302 # 80008478 <syscalls+0xc8>
    b->next = bcache.head.next;
    800025ae:	2b893783          	ld	a5,696(s2)
    800025b2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800025b4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800025b8:	85d2                	mv	a1,s4
    800025ba:	01048513          	addi	a0,s1,16
    800025be:	00001097          	auipc	ra,0x1
    800025c2:	4bc080e7          	jalr	1212(ra) # 80003a7a <initsleeplock>
    bcache.head.next->prev = b;
    800025c6:	2b893783          	ld	a5,696(s2)
    800025ca:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025cc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025d0:	45848493          	addi	s1,s1,1112
    800025d4:	fd349de3          	bne	s1,s3,800025ae <binit+0x54>
  }
}
    800025d8:	70a2                	ld	ra,40(sp)
    800025da:	7402                	ld	s0,32(sp)
    800025dc:	64e2                	ld	s1,24(sp)
    800025de:	6942                	ld	s2,16(sp)
    800025e0:	69a2                	ld	s3,8(sp)
    800025e2:	6a02                	ld	s4,0(sp)
    800025e4:	6145                	addi	sp,sp,48
    800025e6:	8082                	ret

00000000800025e8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800025e8:	7179                	addi	sp,sp,-48
    800025ea:	f406                	sd	ra,40(sp)
    800025ec:	f022                	sd	s0,32(sp)
    800025ee:	ec26                	sd	s1,24(sp)
    800025f0:	e84a                	sd	s2,16(sp)
    800025f2:	e44e                	sd	s3,8(sp)
    800025f4:	1800                	addi	s0,sp,48
    800025f6:	89aa                	mv	s3,a0
    800025f8:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800025fa:	00015517          	auipc	a0,0x15
    800025fe:	89e50513          	addi	a0,a0,-1890 # 80016e98 <bcache>
    80002602:	00004097          	auipc	ra,0x4
    80002606:	220080e7          	jalr	544(ra) # 80006822 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000260a:	0001d497          	auipc	s1,0x1d
    8000260e:	b464b483          	ld	s1,-1210(s1) # 8001f150 <bcache+0x82b8>
    80002612:	0001d797          	auipc	a5,0x1d
    80002616:	aee78793          	addi	a5,a5,-1298 # 8001f100 <bcache+0x8268>
    8000261a:	02f48f63          	beq	s1,a5,80002658 <bread+0x70>
    8000261e:	873e                	mv	a4,a5
    80002620:	a021                	j	80002628 <bread+0x40>
    80002622:	68a4                	ld	s1,80(s1)
    80002624:	02e48a63          	beq	s1,a4,80002658 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002628:	449c                	lw	a5,8(s1)
    8000262a:	ff379ce3          	bne	a5,s3,80002622 <bread+0x3a>
    8000262e:	44dc                	lw	a5,12(s1)
    80002630:	ff2799e3          	bne	a5,s2,80002622 <bread+0x3a>
      b->refcnt++;
    80002634:	40bc                	lw	a5,64(s1)
    80002636:	2785                	addiw	a5,a5,1
    80002638:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000263a:	00015517          	auipc	a0,0x15
    8000263e:	85e50513          	addi	a0,a0,-1954 # 80016e98 <bcache>
    80002642:	00004097          	auipc	ra,0x4
    80002646:	294080e7          	jalr	660(ra) # 800068d6 <release>
      acquiresleep(&b->lock);
    8000264a:	01048513          	addi	a0,s1,16
    8000264e:	00001097          	auipc	ra,0x1
    80002652:	466080e7          	jalr	1126(ra) # 80003ab4 <acquiresleep>
      return b;
    80002656:	a8b9                	j	800026b4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002658:	0001d497          	auipc	s1,0x1d
    8000265c:	af04b483          	ld	s1,-1296(s1) # 8001f148 <bcache+0x82b0>
    80002660:	0001d797          	auipc	a5,0x1d
    80002664:	aa078793          	addi	a5,a5,-1376 # 8001f100 <bcache+0x8268>
    80002668:	00f48863          	beq	s1,a5,80002678 <bread+0x90>
    8000266c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000266e:	40bc                	lw	a5,64(s1)
    80002670:	cf81                	beqz	a5,80002688 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002672:	64a4                	ld	s1,72(s1)
    80002674:	fee49de3          	bne	s1,a4,8000266e <bread+0x86>
  panic("bget: no buffers");
    80002678:	00006517          	auipc	a0,0x6
    8000267c:	e0850513          	addi	a0,a0,-504 # 80008480 <syscalls+0xd0>
    80002680:	00004097          	auipc	ra,0x4
    80002684:	c58080e7          	jalr	-936(ra) # 800062d8 <panic>
      b->dev = dev;
    80002688:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000268c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002690:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002694:	4785                	li	a5,1
    80002696:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002698:	00015517          	auipc	a0,0x15
    8000269c:	80050513          	addi	a0,a0,-2048 # 80016e98 <bcache>
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	236080e7          	jalr	566(ra) # 800068d6 <release>
      acquiresleep(&b->lock);
    800026a8:	01048513          	addi	a0,s1,16
    800026ac:	00001097          	auipc	ra,0x1
    800026b0:	408080e7          	jalr	1032(ra) # 80003ab4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800026b4:	409c                	lw	a5,0(s1)
    800026b6:	cb89                	beqz	a5,800026c8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026b8:	8526                	mv	a0,s1
    800026ba:	70a2                	ld	ra,40(sp)
    800026bc:	7402                	ld	s0,32(sp)
    800026be:	64e2                	ld	s1,24(sp)
    800026c0:	6942                	ld	s2,16(sp)
    800026c2:	69a2                	ld	s3,8(sp)
    800026c4:	6145                	addi	sp,sp,48
    800026c6:	8082                	ret
    virtio_disk_rw(b, 0);
    800026c8:	4581                	li	a1,0
    800026ca:	8526                	mv	a0,s1
    800026cc:	00003097          	auipc	ra,0x3
    800026d0:	34a080e7          	jalr	842(ra) # 80005a16 <virtio_disk_rw>
    b->valid = 1;
    800026d4:	4785                	li	a5,1
    800026d6:	c09c                	sw	a5,0(s1)
  return b;
    800026d8:	b7c5                	j	800026b8 <bread+0xd0>

00000000800026da <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	1000                	addi	s0,sp,32
    800026e4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026e6:	0541                	addi	a0,a0,16
    800026e8:	00001097          	auipc	ra,0x1
    800026ec:	466080e7          	jalr	1126(ra) # 80003b4e <holdingsleep>
    800026f0:	cd01                	beqz	a0,80002708 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026f2:	4585                	li	a1,1
    800026f4:	8526                	mv	a0,s1
    800026f6:	00003097          	auipc	ra,0x3
    800026fa:	320080e7          	jalr	800(ra) # 80005a16 <virtio_disk_rw>
}
    800026fe:	60e2                	ld	ra,24(sp)
    80002700:	6442                	ld	s0,16(sp)
    80002702:	64a2                	ld	s1,8(sp)
    80002704:	6105                	addi	sp,sp,32
    80002706:	8082                	ret
    panic("bwrite");
    80002708:	00006517          	auipc	a0,0x6
    8000270c:	d9050513          	addi	a0,a0,-624 # 80008498 <syscalls+0xe8>
    80002710:	00004097          	auipc	ra,0x4
    80002714:	bc8080e7          	jalr	-1080(ra) # 800062d8 <panic>

0000000080002718 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002718:	1101                	addi	sp,sp,-32
    8000271a:	ec06                	sd	ra,24(sp)
    8000271c:	e822                	sd	s0,16(sp)
    8000271e:	e426                	sd	s1,8(sp)
    80002720:	e04a                	sd	s2,0(sp)
    80002722:	1000                	addi	s0,sp,32
    80002724:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002726:	01050913          	addi	s2,a0,16
    8000272a:	854a                	mv	a0,s2
    8000272c:	00001097          	auipc	ra,0x1
    80002730:	422080e7          	jalr	1058(ra) # 80003b4e <holdingsleep>
    80002734:	c92d                	beqz	a0,800027a6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002736:	854a                	mv	a0,s2
    80002738:	00001097          	auipc	ra,0x1
    8000273c:	3d2080e7          	jalr	978(ra) # 80003b0a <releasesleep>

  acquire(&bcache.lock);
    80002740:	00014517          	auipc	a0,0x14
    80002744:	75850513          	addi	a0,a0,1880 # 80016e98 <bcache>
    80002748:	00004097          	auipc	ra,0x4
    8000274c:	0da080e7          	jalr	218(ra) # 80006822 <acquire>
  b->refcnt--;
    80002750:	40bc                	lw	a5,64(s1)
    80002752:	37fd                	addiw	a5,a5,-1
    80002754:	0007871b          	sext.w	a4,a5
    80002758:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000275a:	eb05                	bnez	a4,8000278a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000275c:	68bc                	ld	a5,80(s1)
    8000275e:	64b8                	ld	a4,72(s1)
    80002760:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002762:	64bc                	ld	a5,72(s1)
    80002764:	68b8                	ld	a4,80(s1)
    80002766:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002768:	0001c797          	auipc	a5,0x1c
    8000276c:	73078793          	addi	a5,a5,1840 # 8001ee98 <bcache+0x8000>
    80002770:	2b87b703          	ld	a4,696(a5)
    80002774:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002776:	0001d717          	auipc	a4,0x1d
    8000277a:	98a70713          	addi	a4,a4,-1654 # 8001f100 <bcache+0x8268>
    8000277e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002780:	2b87b703          	ld	a4,696(a5)
    80002784:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002786:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000278a:	00014517          	auipc	a0,0x14
    8000278e:	70e50513          	addi	a0,a0,1806 # 80016e98 <bcache>
    80002792:	00004097          	auipc	ra,0x4
    80002796:	144080e7          	jalr	324(ra) # 800068d6 <release>
}
    8000279a:	60e2                	ld	ra,24(sp)
    8000279c:	6442                	ld	s0,16(sp)
    8000279e:	64a2                	ld	s1,8(sp)
    800027a0:	6902                	ld	s2,0(sp)
    800027a2:	6105                	addi	sp,sp,32
    800027a4:	8082                	ret
    panic("brelse");
    800027a6:	00006517          	auipc	a0,0x6
    800027aa:	cfa50513          	addi	a0,a0,-774 # 800084a0 <syscalls+0xf0>
    800027ae:	00004097          	auipc	ra,0x4
    800027b2:	b2a080e7          	jalr	-1238(ra) # 800062d8 <panic>

00000000800027b6 <bpin>:

void
bpin(struct buf *b) {
    800027b6:	1101                	addi	sp,sp,-32
    800027b8:	ec06                	sd	ra,24(sp)
    800027ba:	e822                	sd	s0,16(sp)
    800027bc:	e426                	sd	s1,8(sp)
    800027be:	1000                	addi	s0,sp,32
    800027c0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027c2:	00014517          	auipc	a0,0x14
    800027c6:	6d650513          	addi	a0,a0,1750 # 80016e98 <bcache>
    800027ca:	00004097          	auipc	ra,0x4
    800027ce:	058080e7          	jalr	88(ra) # 80006822 <acquire>
  b->refcnt++;
    800027d2:	40bc                	lw	a5,64(s1)
    800027d4:	2785                	addiw	a5,a5,1
    800027d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027d8:	00014517          	auipc	a0,0x14
    800027dc:	6c050513          	addi	a0,a0,1728 # 80016e98 <bcache>
    800027e0:	00004097          	auipc	ra,0x4
    800027e4:	0f6080e7          	jalr	246(ra) # 800068d6 <release>
}
    800027e8:	60e2                	ld	ra,24(sp)
    800027ea:	6442                	ld	s0,16(sp)
    800027ec:	64a2                	ld	s1,8(sp)
    800027ee:	6105                	addi	sp,sp,32
    800027f0:	8082                	ret

00000000800027f2 <bunpin>:

void
bunpin(struct buf *b) {
    800027f2:	1101                	addi	sp,sp,-32
    800027f4:	ec06                	sd	ra,24(sp)
    800027f6:	e822                	sd	s0,16(sp)
    800027f8:	e426                	sd	s1,8(sp)
    800027fa:	1000                	addi	s0,sp,32
    800027fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027fe:	00014517          	auipc	a0,0x14
    80002802:	69a50513          	addi	a0,a0,1690 # 80016e98 <bcache>
    80002806:	00004097          	auipc	ra,0x4
    8000280a:	01c080e7          	jalr	28(ra) # 80006822 <acquire>
  b->refcnt--;
    8000280e:	40bc                	lw	a5,64(s1)
    80002810:	37fd                	addiw	a5,a5,-1
    80002812:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002814:	00014517          	auipc	a0,0x14
    80002818:	68450513          	addi	a0,a0,1668 # 80016e98 <bcache>
    8000281c:	00004097          	auipc	ra,0x4
    80002820:	0ba080e7          	jalr	186(ra) # 800068d6 <release>
}
    80002824:	60e2                	ld	ra,24(sp)
    80002826:	6442                	ld	s0,16(sp)
    80002828:	64a2                	ld	s1,8(sp)
    8000282a:	6105                	addi	sp,sp,32
    8000282c:	8082                	ret

000000008000282e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000282e:	1101                	addi	sp,sp,-32
    80002830:	ec06                	sd	ra,24(sp)
    80002832:	e822                	sd	s0,16(sp)
    80002834:	e426                	sd	s1,8(sp)
    80002836:	e04a                	sd	s2,0(sp)
    80002838:	1000                	addi	s0,sp,32
    8000283a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000283c:	00d5d59b          	srliw	a1,a1,0xd
    80002840:	0001d797          	auipc	a5,0x1d
    80002844:	d347a783          	lw	a5,-716(a5) # 8001f574 <sb+0x1c>
    80002848:	9dbd                	addw	a1,a1,a5
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	d9e080e7          	jalr	-610(ra) # 800025e8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002852:	0074f713          	andi	a4,s1,7
    80002856:	4785                	li	a5,1
    80002858:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000285c:	14ce                	slli	s1,s1,0x33
    8000285e:	90d9                	srli	s1,s1,0x36
    80002860:	00950733          	add	a4,a0,s1
    80002864:	05874703          	lbu	a4,88(a4)
    80002868:	00e7f6b3          	and	a3,a5,a4
    8000286c:	c69d                	beqz	a3,8000289a <bfree+0x6c>
    8000286e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002870:	94aa                	add	s1,s1,a0
    80002872:	fff7c793          	not	a5,a5
    80002876:	8ff9                	and	a5,a5,a4
    80002878:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000287c:	00001097          	auipc	ra,0x1
    80002880:	118080e7          	jalr	280(ra) # 80003994 <log_write>
  brelse(bp);
    80002884:	854a                	mv	a0,s2
    80002886:	00000097          	auipc	ra,0x0
    8000288a:	e92080e7          	jalr	-366(ra) # 80002718 <brelse>
}
    8000288e:	60e2                	ld	ra,24(sp)
    80002890:	6442                	ld	s0,16(sp)
    80002892:	64a2                	ld	s1,8(sp)
    80002894:	6902                	ld	s2,0(sp)
    80002896:	6105                	addi	sp,sp,32
    80002898:	8082                	ret
    panic("freeing free block");
    8000289a:	00006517          	auipc	a0,0x6
    8000289e:	c0e50513          	addi	a0,a0,-1010 # 800084a8 <syscalls+0xf8>
    800028a2:	00004097          	auipc	ra,0x4
    800028a6:	a36080e7          	jalr	-1482(ra) # 800062d8 <panic>

00000000800028aa <balloc>:
{
    800028aa:	711d                	addi	sp,sp,-96
    800028ac:	ec86                	sd	ra,88(sp)
    800028ae:	e8a2                	sd	s0,80(sp)
    800028b0:	e4a6                	sd	s1,72(sp)
    800028b2:	e0ca                	sd	s2,64(sp)
    800028b4:	fc4e                	sd	s3,56(sp)
    800028b6:	f852                	sd	s4,48(sp)
    800028b8:	f456                	sd	s5,40(sp)
    800028ba:	f05a                	sd	s6,32(sp)
    800028bc:	ec5e                	sd	s7,24(sp)
    800028be:	e862                	sd	s8,16(sp)
    800028c0:	e466                	sd	s9,8(sp)
    800028c2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028c4:	0001d797          	auipc	a5,0x1d
    800028c8:	c987a783          	lw	a5,-872(a5) # 8001f55c <sb+0x4>
    800028cc:	cbd1                	beqz	a5,80002960 <balloc+0xb6>
    800028ce:	8baa                	mv	s7,a0
    800028d0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028d2:	0001db17          	auipc	s6,0x1d
    800028d6:	c86b0b13          	addi	s6,s6,-890 # 8001f558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028da:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800028dc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028de:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028e0:	6c89                	lui	s9,0x2
    800028e2:	a831                	j	800028fe <balloc+0x54>
    brelse(bp);
    800028e4:	854a                	mv	a0,s2
    800028e6:	00000097          	auipc	ra,0x0
    800028ea:	e32080e7          	jalr	-462(ra) # 80002718 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028ee:	015c87bb          	addw	a5,s9,s5
    800028f2:	00078a9b          	sext.w	s5,a5
    800028f6:	004b2703          	lw	a4,4(s6)
    800028fa:	06eaf363          	bgeu	s5,a4,80002960 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800028fe:	41fad79b          	sraiw	a5,s5,0x1f
    80002902:	0137d79b          	srliw	a5,a5,0x13
    80002906:	015787bb          	addw	a5,a5,s5
    8000290a:	40d7d79b          	sraiw	a5,a5,0xd
    8000290e:	01cb2583          	lw	a1,28(s6)
    80002912:	9dbd                	addw	a1,a1,a5
    80002914:	855e                	mv	a0,s7
    80002916:	00000097          	auipc	ra,0x0
    8000291a:	cd2080e7          	jalr	-814(ra) # 800025e8 <bread>
    8000291e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002920:	004b2503          	lw	a0,4(s6)
    80002924:	000a849b          	sext.w	s1,s5
    80002928:	8662                	mv	a2,s8
    8000292a:	faa4fde3          	bgeu	s1,a0,800028e4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000292e:	41f6579b          	sraiw	a5,a2,0x1f
    80002932:	01d7d69b          	srliw	a3,a5,0x1d
    80002936:	00c6873b          	addw	a4,a3,a2
    8000293a:	00777793          	andi	a5,a4,7
    8000293e:	9f95                	subw	a5,a5,a3
    80002940:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002944:	4037571b          	sraiw	a4,a4,0x3
    80002948:	00e906b3          	add	a3,s2,a4
    8000294c:	0586c683          	lbu	a3,88(a3)
    80002950:	00d7f5b3          	and	a1,a5,a3
    80002954:	cd91                	beqz	a1,80002970 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002956:	2605                	addiw	a2,a2,1
    80002958:	2485                	addiw	s1,s1,1
    8000295a:	fd4618e3          	bne	a2,s4,8000292a <balloc+0x80>
    8000295e:	b759                	j	800028e4 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002960:	00006517          	auipc	a0,0x6
    80002964:	b6050513          	addi	a0,a0,-1184 # 800084c0 <syscalls+0x110>
    80002968:	00004097          	auipc	ra,0x4
    8000296c:	970080e7          	jalr	-1680(ra) # 800062d8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002970:	974a                	add	a4,a4,s2
    80002972:	8fd5                	or	a5,a5,a3
    80002974:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002978:	854a                	mv	a0,s2
    8000297a:	00001097          	auipc	ra,0x1
    8000297e:	01a080e7          	jalr	26(ra) # 80003994 <log_write>
        brelse(bp);
    80002982:	854a                	mv	a0,s2
    80002984:	00000097          	auipc	ra,0x0
    80002988:	d94080e7          	jalr	-620(ra) # 80002718 <brelse>
  bp = bread(dev, bno);
    8000298c:	85a6                	mv	a1,s1
    8000298e:	855e                	mv	a0,s7
    80002990:	00000097          	auipc	ra,0x0
    80002994:	c58080e7          	jalr	-936(ra) # 800025e8 <bread>
    80002998:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000299a:	40000613          	li	a2,1024
    8000299e:	4581                	li	a1,0
    800029a0:	05850513          	addi	a0,a0,88
    800029a4:	ffffd097          	auipc	ra,0xffffd
    800029a8:	7d4080e7          	jalr	2004(ra) # 80000178 <memset>
  log_write(bp);
    800029ac:	854a                	mv	a0,s2
    800029ae:	00001097          	auipc	ra,0x1
    800029b2:	fe6080e7          	jalr	-26(ra) # 80003994 <log_write>
  brelse(bp);
    800029b6:	854a                	mv	a0,s2
    800029b8:	00000097          	auipc	ra,0x0
    800029bc:	d60080e7          	jalr	-672(ra) # 80002718 <brelse>
}
    800029c0:	8526                	mv	a0,s1
    800029c2:	60e6                	ld	ra,88(sp)
    800029c4:	6446                	ld	s0,80(sp)
    800029c6:	64a6                	ld	s1,72(sp)
    800029c8:	6906                	ld	s2,64(sp)
    800029ca:	79e2                	ld	s3,56(sp)
    800029cc:	7a42                	ld	s4,48(sp)
    800029ce:	7aa2                	ld	s5,40(sp)
    800029d0:	7b02                	ld	s6,32(sp)
    800029d2:	6be2                	ld	s7,24(sp)
    800029d4:	6c42                	ld	s8,16(sp)
    800029d6:	6ca2                	ld	s9,8(sp)
    800029d8:	6125                	addi	sp,sp,96
    800029da:	8082                	ret

00000000800029dc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800029dc:	7179                	addi	sp,sp,-48
    800029de:	f406                	sd	ra,40(sp)
    800029e0:	f022                	sd	s0,32(sp)
    800029e2:	ec26                	sd	s1,24(sp)
    800029e4:	e84a                	sd	s2,16(sp)
    800029e6:	e44e                	sd	s3,8(sp)
    800029e8:	e052                	sd	s4,0(sp)
    800029ea:	1800                	addi	s0,sp,48
    800029ec:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029ee:	47ad                	li	a5,11
    800029f0:	04b7fe63          	bgeu	a5,a1,80002a4c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800029f4:	ff45849b          	addiw	s1,a1,-12
    800029f8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029fc:	0ff00793          	li	a5,255
    80002a00:	0ae7e363          	bltu	a5,a4,80002aa6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002a04:	08052583          	lw	a1,128(a0)
    80002a08:	c5ad                	beqz	a1,80002a72 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002a0a:	00092503          	lw	a0,0(s2)
    80002a0e:	00000097          	auipc	ra,0x0
    80002a12:	bda080e7          	jalr	-1062(ra) # 800025e8 <bread>
    80002a16:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a18:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a1c:	02049593          	slli	a1,s1,0x20
    80002a20:	9181                	srli	a1,a1,0x20
    80002a22:	058a                	slli	a1,a1,0x2
    80002a24:	00b784b3          	add	s1,a5,a1
    80002a28:	0004a983          	lw	s3,0(s1)
    80002a2c:	04098d63          	beqz	s3,80002a86 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002a30:	8552                	mv	a0,s4
    80002a32:	00000097          	auipc	ra,0x0
    80002a36:	ce6080e7          	jalr	-794(ra) # 80002718 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a3a:	854e                	mv	a0,s3
    80002a3c:	70a2                	ld	ra,40(sp)
    80002a3e:	7402                	ld	s0,32(sp)
    80002a40:	64e2                	ld	s1,24(sp)
    80002a42:	6942                	ld	s2,16(sp)
    80002a44:	69a2                	ld	s3,8(sp)
    80002a46:	6a02                	ld	s4,0(sp)
    80002a48:	6145                	addi	sp,sp,48
    80002a4a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002a4c:	02059493          	slli	s1,a1,0x20
    80002a50:	9081                	srli	s1,s1,0x20
    80002a52:	048a                	slli	s1,s1,0x2
    80002a54:	94aa                	add	s1,s1,a0
    80002a56:	0504a983          	lw	s3,80(s1)
    80002a5a:	fe0990e3          	bnez	s3,80002a3a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002a5e:	4108                	lw	a0,0(a0)
    80002a60:	00000097          	auipc	ra,0x0
    80002a64:	e4a080e7          	jalr	-438(ra) # 800028aa <balloc>
    80002a68:	0005099b          	sext.w	s3,a0
    80002a6c:	0534a823          	sw	s3,80(s1)
    80002a70:	b7e9                	j	80002a3a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a72:	4108                	lw	a0,0(a0)
    80002a74:	00000097          	auipc	ra,0x0
    80002a78:	e36080e7          	jalr	-458(ra) # 800028aa <balloc>
    80002a7c:	0005059b          	sext.w	a1,a0
    80002a80:	08b92023          	sw	a1,128(s2)
    80002a84:	b759                	j	80002a0a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a86:	00092503          	lw	a0,0(s2)
    80002a8a:	00000097          	auipc	ra,0x0
    80002a8e:	e20080e7          	jalr	-480(ra) # 800028aa <balloc>
    80002a92:	0005099b          	sext.w	s3,a0
    80002a96:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a9a:	8552                	mv	a0,s4
    80002a9c:	00001097          	auipc	ra,0x1
    80002aa0:	ef8080e7          	jalr	-264(ra) # 80003994 <log_write>
    80002aa4:	b771                	j	80002a30 <bmap+0x54>
  panic("bmap: out of range");
    80002aa6:	00006517          	auipc	a0,0x6
    80002aaa:	a3250513          	addi	a0,a0,-1486 # 800084d8 <syscalls+0x128>
    80002aae:	00004097          	auipc	ra,0x4
    80002ab2:	82a080e7          	jalr	-2006(ra) # 800062d8 <panic>

0000000080002ab6 <iget>:
{
    80002ab6:	7179                	addi	sp,sp,-48
    80002ab8:	f406                	sd	ra,40(sp)
    80002aba:	f022                	sd	s0,32(sp)
    80002abc:	ec26                	sd	s1,24(sp)
    80002abe:	e84a                	sd	s2,16(sp)
    80002ac0:	e44e                	sd	s3,8(sp)
    80002ac2:	e052                	sd	s4,0(sp)
    80002ac4:	1800                	addi	s0,sp,48
    80002ac6:	89aa                	mv	s3,a0
    80002ac8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002aca:	0001d517          	auipc	a0,0x1d
    80002ace:	aae50513          	addi	a0,a0,-1362 # 8001f578 <itable>
    80002ad2:	00004097          	auipc	ra,0x4
    80002ad6:	d50080e7          	jalr	-688(ra) # 80006822 <acquire>
  empty = 0;
    80002ada:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002adc:	0001d497          	auipc	s1,0x1d
    80002ae0:	ab448493          	addi	s1,s1,-1356 # 8001f590 <itable+0x18>
    80002ae4:	0001e697          	auipc	a3,0x1e
    80002ae8:	53c68693          	addi	a3,a3,1340 # 80021020 <log>
    80002aec:	a039                	j	80002afa <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aee:	02090b63          	beqz	s2,80002b24 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002af2:	08848493          	addi	s1,s1,136
    80002af6:	02d48a63          	beq	s1,a3,80002b2a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002afa:	449c                	lw	a5,8(s1)
    80002afc:	fef059e3          	blez	a5,80002aee <iget+0x38>
    80002b00:	4098                	lw	a4,0(s1)
    80002b02:	ff3716e3          	bne	a4,s3,80002aee <iget+0x38>
    80002b06:	40d8                	lw	a4,4(s1)
    80002b08:	ff4713e3          	bne	a4,s4,80002aee <iget+0x38>
      ip->ref++;
    80002b0c:	2785                	addiw	a5,a5,1
    80002b0e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b10:	0001d517          	auipc	a0,0x1d
    80002b14:	a6850513          	addi	a0,a0,-1432 # 8001f578 <itable>
    80002b18:	00004097          	auipc	ra,0x4
    80002b1c:	dbe080e7          	jalr	-578(ra) # 800068d6 <release>
      return ip;
    80002b20:	8926                	mv	s2,s1
    80002b22:	a03d                	j	80002b50 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b24:	f7f9                	bnez	a5,80002af2 <iget+0x3c>
    80002b26:	8926                	mv	s2,s1
    80002b28:	b7e9                	j	80002af2 <iget+0x3c>
  if(empty == 0)
    80002b2a:	02090c63          	beqz	s2,80002b62 <iget+0xac>
  ip->dev = dev;
    80002b2e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b32:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b36:	4785                	li	a5,1
    80002b38:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b3c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b40:	0001d517          	auipc	a0,0x1d
    80002b44:	a3850513          	addi	a0,a0,-1480 # 8001f578 <itable>
    80002b48:	00004097          	auipc	ra,0x4
    80002b4c:	d8e080e7          	jalr	-626(ra) # 800068d6 <release>
}
    80002b50:	854a                	mv	a0,s2
    80002b52:	70a2                	ld	ra,40(sp)
    80002b54:	7402                	ld	s0,32(sp)
    80002b56:	64e2                	ld	s1,24(sp)
    80002b58:	6942                	ld	s2,16(sp)
    80002b5a:	69a2                	ld	s3,8(sp)
    80002b5c:	6a02                	ld	s4,0(sp)
    80002b5e:	6145                	addi	sp,sp,48
    80002b60:	8082                	ret
    panic("iget: no inodes");
    80002b62:	00006517          	auipc	a0,0x6
    80002b66:	98e50513          	addi	a0,a0,-1650 # 800084f0 <syscalls+0x140>
    80002b6a:	00003097          	auipc	ra,0x3
    80002b6e:	76e080e7          	jalr	1902(ra) # 800062d8 <panic>

0000000080002b72 <fsinit>:
fsinit(int dev) {
    80002b72:	7179                	addi	sp,sp,-48
    80002b74:	f406                	sd	ra,40(sp)
    80002b76:	f022                	sd	s0,32(sp)
    80002b78:	ec26                	sd	s1,24(sp)
    80002b7a:	e84a                	sd	s2,16(sp)
    80002b7c:	e44e                	sd	s3,8(sp)
    80002b7e:	1800                	addi	s0,sp,48
    80002b80:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b82:	4585                	li	a1,1
    80002b84:	00000097          	auipc	ra,0x0
    80002b88:	a64080e7          	jalr	-1436(ra) # 800025e8 <bread>
    80002b8c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b8e:	0001d997          	auipc	s3,0x1d
    80002b92:	9ca98993          	addi	s3,s3,-1590 # 8001f558 <sb>
    80002b96:	02000613          	li	a2,32
    80002b9a:	05850593          	addi	a1,a0,88
    80002b9e:	854e                	mv	a0,s3
    80002ba0:	ffffd097          	auipc	ra,0xffffd
    80002ba4:	638080e7          	jalr	1592(ra) # 800001d8 <memmove>
  brelse(bp);
    80002ba8:	8526                	mv	a0,s1
    80002baa:	00000097          	auipc	ra,0x0
    80002bae:	b6e080e7          	jalr	-1170(ra) # 80002718 <brelse>
  if(sb.magic != FSMAGIC)
    80002bb2:	0009a703          	lw	a4,0(s3)
    80002bb6:	102037b7          	lui	a5,0x10203
    80002bba:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bbe:	02f71263          	bne	a4,a5,80002be2 <fsinit+0x70>
  initlog(dev, &sb);
    80002bc2:	0001d597          	auipc	a1,0x1d
    80002bc6:	99658593          	addi	a1,a1,-1642 # 8001f558 <sb>
    80002bca:	854a                	mv	a0,s2
    80002bcc:	00001097          	auipc	ra,0x1
    80002bd0:	b4c080e7          	jalr	-1204(ra) # 80003718 <initlog>
}
    80002bd4:	70a2                	ld	ra,40(sp)
    80002bd6:	7402                	ld	s0,32(sp)
    80002bd8:	64e2                	ld	s1,24(sp)
    80002bda:	6942                	ld	s2,16(sp)
    80002bdc:	69a2                	ld	s3,8(sp)
    80002bde:	6145                	addi	sp,sp,48
    80002be0:	8082                	ret
    panic("invalid file system");
    80002be2:	00006517          	auipc	a0,0x6
    80002be6:	91e50513          	addi	a0,a0,-1762 # 80008500 <syscalls+0x150>
    80002bea:	00003097          	auipc	ra,0x3
    80002bee:	6ee080e7          	jalr	1774(ra) # 800062d8 <panic>

0000000080002bf2 <iinit>:
{
    80002bf2:	7179                	addi	sp,sp,-48
    80002bf4:	f406                	sd	ra,40(sp)
    80002bf6:	f022                	sd	s0,32(sp)
    80002bf8:	ec26                	sd	s1,24(sp)
    80002bfa:	e84a                	sd	s2,16(sp)
    80002bfc:	e44e                	sd	s3,8(sp)
    80002bfe:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c00:	00006597          	auipc	a1,0x6
    80002c04:	91858593          	addi	a1,a1,-1768 # 80008518 <syscalls+0x168>
    80002c08:	0001d517          	auipc	a0,0x1d
    80002c0c:	97050513          	addi	a0,a0,-1680 # 8001f578 <itable>
    80002c10:	00004097          	auipc	ra,0x4
    80002c14:	b82080e7          	jalr	-1150(ra) # 80006792 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c18:	0001d497          	auipc	s1,0x1d
    80002c1c:	98848493          	addi	s1,s1,-1656 # 8001f5a0 <itable+0x28>
    80002c20:	0001e997          	auipc	s3,0x1e
    80002c24:	41098993          	addi	s3,s3,1040 # 80021030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c28:	00006917          	auipc	s2,0x6
    80002c2c:	8f890913          	addi	s2,s2,-1800 # 80008520 <syscalls+0x170>
    80002c30:	85ca                	mv	a1,s2
    80002c32:	8526                	mv	a0,s1
    80002c34:	00001097          	auipc	ra,0x1
    80002c38:	e46080e7          	jalr	-442(ra) # 80003a7a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c3c:	08848493          	addi	s1,s1,136
    80002c40:	ff3498e3          	bne	s1,s3,80002c30 <iinit+0x3e>
}
    80002c44:	70a2                	ld	ra,40(sp)
    80002c46:	7402                	ld	s0,32(sp)
    80002c48:	64e2                	ld	s1,24(sp)
    80002c4a:	6942                	ld	s2,16(sp)
    80002c4c:	69a2                	ld	s3,8(sp)
    80002c4e:	6145                	addi	sp,sp,48
    80002c50:	8082                	ret

0000000080002c52 <ialloc>:
{
    80002c52:	715d                	addi	sp,sp,-80
    80002c54:	e486                	sd	ra,72(sp)
    80002c56:	e0a2                	sd	s0,64(sp)
    80002c58:	fc26                	sd	s1,56(sp)
    80002c5a:	f84a                	sd	s2,48(sp)
    80002c5c:	f44e                	sd	s3,40(sp)
    80002c5e:	f052                	sd	s4,32(sp)
    80002c60:	ec56                	sd	s5,24(sp)
    80002c62:	e85a                	sd	s6,16(sp)
    80002c64:	e45e                	sd	s7,8(sp)
    80002c66:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c68:	0001d717          	auipc	a4,0x1d
    80002c6c:	8fc72703          	lw	a4,-1796(a4) # 8001f564 <sb+0xc>
    80002c70:	4785                	li	a5,1
    80002c72:	04e7fa63          	bgeu	a5,a4,80002cc6 <ialloc+0x74>
    80002c76:	8aaa                	mv	s5,a0
    80002c78:	8bae                	mv	s7,a1
    80002c7a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c7c:	0001da17          	auipc	s4,0x1d
    80002c80:	8dca0a13          	addi	s4,s4,-1828 # 8001f558 <sb>
    80002c84:	00048b1b          	sext.w	s6,s1
    80002c88:	0044d593          	srli	a1,s1,0x4
    80002c8c:	018a2783          	lw	a5,24(s4)
    80002c90:	9dbd                	addw	a1,a1,a5
    80002c92:	8556                	mv	a0,s5
    80002c94:	00000097          	auipc	ra,0x0
    80002c98:	954080e7          	jalr	-1708(ra) # 800025e8 <bread>
    80002c9c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c9e:	05850993          	addi	s3,a0,88
    80002ca2:	00f4f793          	andi	a5,s1,15
    80002ca6:	079a                	slli	a5,a5,0x6
    80002ca8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002caa:	00099783          	lh	a5,0(s3)
    80002cae:	c785                	beqz	a5,80002cd6 <ialloc+0x84>
    brelse(bp);
    80002cb0:	00000097          	auipc	ra,0x0
    80002cb4:	a68080e7          	jalr	-1432(ra) # 80002718 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cb8:	0485                	addi	s1,s1,1
    80002cba:	00ca2703          	lw	a4,12(s4)
    80002cbe:	0004879b          	sext.w	a5,s1
    80002cc2:	fce7e1e3          	bltu	a5,a4,80002c84 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002cc6:	00006517          	auipc	a0,0x6
    80002cca:	86250513          	addi	a0,a0,-1950 # 80008528 <syscalls+0x178>
    80002cce:	00003097          	auipc	ra,0x3
    80002cd2:	60a080e7          	jalr	1546(ra) # 800062d8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002cd6:	04000613          	li	a2,64
    80002cda:	4581                	li	a1,0
    80002cdc:	854e                	mv	a0,s3
    80002cde:	ffffd097          	auipc	ra,0xffffd
    80002ce2:	49a080e7          	jalr	1178(ra) # 80000178 <memset>
      dip->type = type;
    80002ce6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002cea:	854a                	mv	a0,s2
    80002cec:	00001097          	auipc	ra,0x1
    80002cf0:	ca8080e7          	jalr	-856(ra) # 80003994 <log_write>
      brelse(bp);
    80002cf4:	854a                	mv	a0,s2
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	a22080e7          	jalr	-1502(ra) # 80002718 <brelse>
      return iget(dev, inum);
    80002cfe:	85da                	mv	a1,s6
    80002d00:	8556                	mv	a0,s5
    80002d02:	00000097          	auipc	ra,0x0
    80002d06:	db4080e7          	jalr	-588(ra) # 80002ab6 <iget>
}
    80002d0a:	60a6                	ld	ra,72(sp)
    80002d0c:	6406                	ld	s0,64(sp)
    80002d0e:	74e2                	ld	s1,56(sp)
    80002d10:	7942                	ld	s2,48(sp)
    80002d12:	79a2                	ld	s3,40(sp)
    80002d14:	7a02                	ld	s4,32(sp)
    80002d16:	6ae2                	ld	s5,24(sp)
    80002d18:	6b42                	ld	s6,16(sp)
    80002d1a:	6ba2                	ld	s7,8(sp)
    80002d1c:	6161                	addi	sp,sp,80
    80002d1e:	8082                	ret

0000000080002d20 <iupdate>:
{
    80002d20:	1101                	addi	sp,sp,-32
    80002d22:	ec06                	sd	ra,24(sp)
    80002d24:	e822                	sd	s0,16(sp)
    80002d26:	e426                	sd	s1,8(sp)
    80002d28:	e04a                	sd	s2,0(sp)
    80002d2a:	1000                	addi	s0,sp,32
    80002d2c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d2e:	415c                	lw	a5,4(a0)
    80002d30:	0047d79b          	srliw	a5,a5,0x4
    80002d34:	0001d597          	auipc	a1,0x1d
    80002d38:	83c5a583          	lw	a1,-1988(a1) # 8001f570 <sb+0x18>
    80002d3c:	9dbd                	addw	a1,a1,a5
    80002d3e:	4108                	lw	a0,0(a0)
    80002d40:	00000097          	auipc	ra,0x0
    80002d44:	8a8080e7          	jalr	-1880(ra) # 800025e8 <bread>
    80002d48:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d4a:	05850793          	addi	a5,a0,88
    80002d4e:	40c8                	lw	a0,4(s1)
    80002d50:	893d                	andi	a0,a0,15
    80002d52:	051a                	slli	a0,a0,0x6
    80002d54:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002d56:	04449703          	lh	a4,68(s1)
    80002d5a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002d5e:	04649703          	lh	a4,70(s1)
    80002d62:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002d66:	04849703          	lh	a4,72(s1)
    80002d6a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002d6e:	04a49703          	lh	a4,74(s1)
    80002d72:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d76:	44f8                	lw	a4,76(s1)
    80002d78:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d7a:	03400613          	li	a2,52
    80002d7e:	05048593          	addi	a1,s1,80
    80002d82:	0531                	addi	a0,a0,12
    80002d84:	ffffd097          	auipc	ra,0xffffd
    80002d88:	454080e7          	jalr	1108(ra) # 800001d8 <memmove>
  log_write(bp);
    80002d8c:	854a                	mv	a0,s2
    80002d8e:	00001097          	auipc	ra,0x1
    80002d92:	c06080e7          	jalr	-1018(ra) # 80003994 <log_write>
  brelse(bp);
    80002d96:	854a                	mv	a0,s2
    80002d98:	00000097          	auipc	ra,0x0
    80002d9c:	980080e7          	jalr	-1664(ra) # 80002718 <brelse>
}
    80002da0:	60e2                	ld	ra,24(sp)
    80002da2:	6442                	ld	s0,16(sp)
    80002da4:	64a2                	ld	s1,8(sp)
    80002da6:	6902                	ld	s2,0(sp)
    80002da8:	6105                	addi	sp,sp,32
    80002daa:	8082                	ret

0000000080002dac <idup>:
{
    80002dac:	1101                	addi	sp,sp,-32
    80002dae:	ec06                	sd	ra,24(sp)
    80002db0:	e822                	sd	s0,16(sp)
    80002db2:	e426                	sd	s1,8(sp)
    80002db4:	1000                	addi	s0,sp,32
    80002db6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002db8:	0001c517          	auipc	a0,0x1c
    80002dbc:	7c050513          	addi	a0,a0,1984 # 8001f578 <itable>
    80002dc0:	00004097          	auipc	ra,0x4
    80002dc4:	a62080e7          	jalr	-1438(ra) # 80006822 <acquire>
  ip->ref++;
    80002dc8:	449c                	lw	a5,8(s1)
    80002dca:	2785                	addiw	a5,a5,1
    80002dcc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dce:	0001c517          	auipc	a0,0x1c
    80002dd2:	7aa50513          	addi	a0,a0,1962 # 8001f578 <itable>
    80002dd6:	00004097          	auipc	ra,0x4
    80002dda:	b00080e7          	jalr	-1280(ra) # 800068d6 <release>
}
    80002dde:	8526                	mv	a0,s1
    80002de0:	60e2                	ld	ra,24(sp)
    80002de2:	6442                	ld	s0,16(sp)
    80002de4:	64a2                	ld	s1,8(sp)
    80002de6:	6105                	addi	sp,sp,32
    80002de8:	8082                	ret

0000000080002dea <ilock>:
{
    80002dea:	1101                	addi	sp,sp,-32
    80002dec:	ec06                	sd	ra,24(sp)
    80002dee:	e822                	sd	s0,16(sp)
    80002df0:	e426                	sd	s1,8(sp)
    80002df2:	e04a                	sd	s2,0(sp)
    80002df4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002df6:	c115                	beqz	a0,80002e1a <ilock+0x30>
    80002df8:	84aa                	mv	s1,a0
    80002dfa:	451c                	lw	a5,8(a0)
    80002dfc:	00f05f63          	blez	a5,80002e1a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002e00:	0541                	addi	a0,a0,16
    80002e02:	00001097          	auipc	ra,0x1
    80002e06:	cb2080e7          	jalr	-846(ra) # 80003ab4 <acquiresleep>
  if(ip->valid == 0){
    80002e0a:	40bc                	lw	a5,64(s1)
    80002e0c:	cf99                	beqz	a5,80002e2a <ilock+0x40>
}
    80002e0e:	60e2                	ld	ra,24(sp)
    80002e10:	6442                	ld	s0,16(sp)
    80002e12:	64a2                	ld	s1,8(sp)
    80002e14:	6902                	ld	s2,0(sp)
    80002e16:	6105                	addi	sp,sp,32
    80002e18:	8082                	ret
    panic("ilock");
    80002e1a:	00005517          	auipc	a0,0x5
    80002e1e:	72650513          	addi	a0,a0,1830 # 80008540 <syscalls+0x190>
    80002e22:	00003097          	auipc	ra,0x3
    80002e26:	4b6080e7          	jalr	1206(ra) # 800062d8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e2a:	40dc                	lw	a5,4(s1)
    80002e2c:	0047d79b          	srliw	a5,a5,0x4
    80002e30:	0001c597          	auipc	a1,0x1c
    80002e34:	7405a583          	lw	a1,1856(a1) # 8001f570 <sb+0x18>
    80002e38:	9dbd                	addw	a1,a1,a5
    80002e3a:	4088                	lw	a0,0(s1)
    80002e3c:	fffff097          	auipc	ra,0xfffff
    80002e40:	7ac080e7          	jalr	1964(ra) # 800025e8 <bread>
    80002e44:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e46:	05850593          	addi	a1,a0,88
    80002e4a:	40dc                	lw	a5,4(s1)
    80002e4c:	8bbd                	andi	a5,a5,15
    80002e4e:	079a                	slli	a5,a5,0x6
    80002e50:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e52:	00059783          	lh	a5,0(a1)
    80002e56:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e5a:	00259783          	lh	a5,2(a1)
    80002e5e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e62:	00459783          	lh	a5,4(a1)
    80002e66:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e6a:	00659783          	lh	a5,6(a1)
    80002e6e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e72:	459c                	lw	a5,8(a1)
    80002e74:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e76:	03400613          	li	a2,52
    80002e7a:	05b1                	addi	a1,a1,12
    80002e7c:	05048513          	addi	a0,s1,80
    80002e80:	ffffd097          	auipc	ra,0xffffd
    80002e84:	358080e7          	jalr	856(ra) # 800001d8 <memmove>
    brelse(bp);
    80002e88:	854a                	mv	a0,s2
    80002e8a:	00000097          	auipc	ra,0x0
    80002e8e:	88e080e7          	jalr	-1906(ra) # 80002718 <brelse>
    ip->valid = 1;
    80002e92:	4785                	li	a5,1
    80002e94:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e96:	04449783          	lh	a5,68(s1)
    80002e9a:	fbb5                	bnez	a5,80002e0e <ilock+0x24>
      panic("ilock: no type");
    80002e9c:	00005517          	auipc	a0,0x5
    80002ea0:	6ac50513          	addi	a0,a0,1708 # 80008548 <syscalls+0x198>
    80002ea4:	00003097          	auipc	ra,0x3
    80002ea8:	434080e7          	jalr	1076(ra) # 800062d8 <panic>

0000000080002eac <iunlock>:
{
    80002eac:	1101                	addi	sp,sp,-32
    80002eae:	ec06                	sd	ra,24(sp)
    80002eb0:	e822                	sd	s0,16(sp)
    80002eb2:	e426                	sd	s1,8(sp)
    80002eb4:	e04a                	sd	s2,0(sp)
    80002eb6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002eb8:	c905                	beqz	a0,80002ee8 <iunlock+0x3c>
    80002eba:	84aa                	mv	s1,a0
    80002ebc:	01050913          	addi	s2,a0,16
    80002ec0:	854a                	mv	a0,s2
    80002ec2:	00001097          	auipc	ra,0x1
    80002ec6:	c8c080e7          	jalr	-884(ra) # 80003b4e <holdingsleep>
    80002eca:	cd19                	beqz	a0,80002ee8 <iunlock+0x3c>
    80002ecc:	449c                	lw	a5,8(s1)
    80002ece:	00f05d63          	blez	a5,80002ee8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ed2:	854a                	mv	a0,s2
    80002ed4:	00001097          	auipc	ra,0x1
    80002ed8:	c36080e7          	jalr	-970(ra) # 80003b0a <releasesleep>
}
    80002edc:	60e2                	ld	ra,24(sp)
    80002ede:	6442                	ld	s0,16(sp)
    80002ee0:	64a2                	ld	s1,8(sp)
    80002ee2:	6902                	ld	s2,0(sp)
    80002ee4:	6105                	addi	sp,sp,32
    80002ee6:	8082                	ret
    panic("iunlock");
    80002ee8:	00005517          	auipc	a0,0x5
    80002eec:	67050513          	addi	a0,a0,1648 # 80008558 <syscalls+0x1a8>
    80002ef0:	00003097          	auipc	ra,0x3
    80002ef4:	3e8080e7          	jalr	1000(ra) # 800062d8 <panic>

0000000080002ef8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ef8:	7179                	addi	sp,sp,-48
    80002efa:	f406                	sd	ra,40(sp)
    80002efc:	f022                	sd	s0,32(sp)
    80002efe:	ec26                	sd	s1,24(sp)
    80002f00:	e84a                	sd	s2,16(sp)
    80002f02:	e44e                	sd	s3,8(sp)
    80002f04:	e052                	sd	s4,0(sp)
    80002f06:	1800                	addi	s0,sp,48
    80002f08:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f0a:	05050493          	addi	s1,a0,80
    80002f0e:	08050913          	addi	s2,a0,128
    80002f12:	a021                	j	80002f1a <itrunc+0x22>
    80002f14:	0491                	addi	s1,s1,4
    80002f16:	01248d63          	beq	s1,s2,80002f30 <itrunc+0x38>
    if(ip->addrs[i]){
    80002f1a:	408c                	lw	a1,0(s1)
    80002f1c:	dde5                	beqz	a1,80002f14 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f1e:	0009a503          	lw	a0,0(s3)
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	90c080e7          	jalr	-1780(ra) # 8000282e <bfree>
      ip->addrs[i] = 0;
    80002f2a:	0004a023          	sw	zero,0(s1)
    80002f2e:	b7dd                	j	80002f14 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f30:	0809a583          	lw	a1,128(s3)
    80002f34:	e185                	bnez	a1,80002f54 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f36:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f3a:	854e                	mv	a0,s3
    80002f3c:	00000097          	auipc	ra,0x0
    80002f40:	de4080e7          	jalr	-540(ra) # 80002d20 <iupdate>
}
    80002f44:	70a2                	ld	ra,40(sp)
    80002f46:	7402                	ld	s0,32(sp)
    80002f48:	64e2                	ld	s1,24(sp)
    80002f4a:	6942                	ld	s2,16(sp)
    80002f4c:	69a2                	ld	s3,8(sp)
    80002f4e:	6a02                	ld	s4,0(sp)
    80002f50:	6145                	addi	sp,sp,48
    80002f52:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f54:	0009a503          	lw	a0,0(s3)
    80002f58:	fffff097          	auipc	ra,0xfffff
    80002f5c:	690080e7          	jalr	1680(ra) # 800025e8 <bread>
    80002f60:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f62:	05850493          	addi	s1,a0,88
    80002f66:	45850913          	addi	s2,a0,1112
    80002f6a:	a811                	j	80002f7e <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002f6c:	0009a503          	lw	a0,0(s3)
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	8be080e7          	jalr	-1858(ra) # 8000282e <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002f78:	0491                	addi	s1,s1,4
    80002f7a:	01248563          	beq	s1,s2,80002f84 <itrunc+0x8c>
      if(a[j])
    80002f7e:	408c                	lw	a1,0(s1)
    80002f80:	dde5                	beqz	a1,80002f78 <itrunc+0x80>
    80002f82:	b7ed                	j	80002f6c <itrunc+0x74>
    brelse(bp);
    80002f84:	8552                	mv	a0,s4
    80002f86:	fffff097          	auipc	ra,0xfffff
    80002f8a:	792080e7          	jalr	1938(ra) # 80002718 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f8e:	0809a583          	lw	a1,128(s3)
    80002f92:	0009a503          	lw	a0,0(s3)
    80002f96:	00000097          	auipc	ra,0x0
    80002f9a:	898080e7          	jalr	-1896(ra) # 8000282e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f9e:	0809a023          	sw	zero,128(s3)
    80002fa2:	bf51                	j	80002f36 <itrunc+0x3e>

0000000080002fa4 <iput>:
{
    80002fa4:	1101                	addi	sp,sp,-32
    80002fa6:	ec06                	sd	ra,24(sp)
    80002fa8:	e822                	sd	s0,16(sp)
    80002faa:	e426                	sd	s1,8(sp)
    80002fac:	e04a                	sd	s2,0(sp)
    80002fae:	1000                	addi	s0,sp,32
    80002fb0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fb2:	0001c517          	auipc	a0,0x1c
    80002fb6:	5c650513          	addi	a0,a0,1478 # 8001f578 <itable>
    80002fba:	00004097          	auipc	ra,0x4
    80002fbe:	868080e7          	jalr	-1944(ra) # 80006822 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fc2:	4498                	lw	a4,8(s1)
    80002fc4:	4785                	li	a5,1
    80002fc6:	02f70363          	beq	a4,a5,80002fec <iput+0x48>
  ip->ref--;
    80002fca:	449c                	lw	a5,8(s1)
    80002fcc:	37fd                	addiw	a5,a5,-1
    80002fce:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002fd0:	0001c517          	auipc	a0,0x1c
    80002fd4:	5a850513          	addi	a0,a0,1448 # 8001f578 <itable>
    80002fd8:	00004097          	auipc	ra,0x4
    80002fdc:	8fe080e7          	jalr	-1794(ra) # 800068d6 <release>
}
    80002fe0:	60e2                	ld	ra,24(sp)
    80002fe2:	6442                	ld	s0,16(sp)
    80002fe4:	64a2                	ld	s1,8(sp)
    80002fe6:	6902                	ld	s2,0(sp)
    80002fe8:	6105                	addi	sp,sp,32
    80002fea:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fec:	40bc                	lw	a5,64(s1)
    80002fee:	dff1                	beqz	a5,80002fca <iput+0x26>
    80002ff0:	04a49783          	lh	a5,74(s1)
    80002ff4:	fbf9                	bnez	a5,80002fca <iput+0x26>
    acquiresleep(&ip->lock);
    80002ff6:	01048913          	addi	s2,s1,16
    80002ffa:	854a                	mv	a0,s2
    80002ffc:	00001097          	auipc	ra,0x1
    80003000:	ab8080e7          	jalr	-1352(ra) # 80003ab4 <acquiresleep>
    release(&itable.lock);
    80003004:	0001c517          	auipc	a0,0x1c
    80003008:	57450513          	addi	a0,a0,1396 # 8001f578 <itable>
    8000300c:	00004097          	auipc	ra,0x4
    80003010:	8ca080e7          	jalr	-1846(ra) # 800068d6 <release>
    itrunc(ip);
    80003014:	8526                	mv	a0,s1
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	ee2080e7          	jalr	-286(ra) # 80002ef8 <itrunc>
    ip->type = 0;
    8000301e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003022:	8526                	mv	a0,s1
    80003024:	00000097          	auipc	ra,0x0
    80003028:	cfc080e7          	jalr	-772(ra) # 80002d20 <iupdate>
    ip->valid = 0;
    8000302c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003030:	854a                	mv	a0,s2
    80003032:	00001097          	auipc	ra,0x1
    80003036:	ad8080e7          	jalr	-1320(ra) # 80003b0a <releasesleep>
    acquire(&itable.lock);
    8000303a:	0001c517          	auipc	a0,0x1c
    8000303e:	53e50513          	addi	a0,a0,1342 # 8001f578 <itable>
    80003042:	00003097          	auipc	ra,0x3
    80003046:	7e0080e7          	jalr	2016(ra) # 80006822 <acquire>
    8000304a:	b741                	j	80002fca <iput+0x26>

000000008000304c <iunlockput>:
{
    8000304c:	1101                	addi	sp,sp,-32
    8000304e:	ec06                	sd	ra,24(sp)
    80003050:	e822                	sd	s0,16(sp)
    80003052:	e426                	sd	s1,8(sp)
    80003054:	1000                	addi	s0,sp,32
    80003056:	84aa                	mv	s1,a0
  iunlock(ip);
    80003058:	00000097          	auipc	ra,0x0
    8000305c:	e54080e7          	jalr	-428(ra) # 80002eac <iunlock>
  iput(ip);
    80003060:	8526                	mv	a0,s1
    80003062:	00000097          	auipc	ra,0x0
    80003066:	f42080e7          	jalr	-190(ra) # 80002fa4 <iput>
}
    8000306a:	60e2                	ld	ra,24(sp)
    8000306c:	6442                	ld	s0,16(sp)
    8000306e:	64a2                	ld	s1,8(sp)
    80003070:	6105                	addi	sp,sp,32
    80003072:	8082                	ret

0000000080003074 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003074:	1141                	addi	sp,sp,-16
    80003076:	e422                	sd	s0,8(sp)
    80003078:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000307a:	411c                	lw	a5,0(a0)
    8000307c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000307e:	415c                	lw	a5,4(a0)
    80003080:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003082:	04451783          	lh	a5,68(a0)
    80003086:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000308a:	04a51783          	lh	a5,74(a0)
    8000308e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003092:	04c56783          	lwu	a5,76(a0)
    80003096:	e99c                	sd	a5,16(a1)
}
    80003098:	6422                	ld	s0,8(sp)
    8000309a:	0141                	addi	sp,sp,16
    8000309c:	8082                	ret

000000008000309e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000309e:	457c                	lw	a5,76(a0)
    800030a0:	0ed7e963          	bltu	a5,a3,80003192 <readi+0xf4>
{
    800030a4:	7159                	addi	sp,sp,-112
    800030a6:	f486                	sd	ra,104(sp)
    800030a8:	f0a2                	sd	s0,96(sp)
    800030aa:	eca6                	sd	s1,88(sp)
    800030ac:	e8ca                	sd	s2,80(sp)
    800030ae:	e4ce                	sd	s3,72(sp)
    800030b0:	e0d2                	sd	s4,64(sp)
    800030b2:	fc56                	sd	s5,56(sp)
    800030b4:	f85a                	sd	s6,48(sp)
    800030b6:	f45e                	sd	s7,40(sp)
    800030b8:	f062                	sd	s8,32(sp)
    800030ba:	ec66                	sd	s9,24(sp)
    800030bc:	e86a                	sd	s10,16(sp)
    800030be:	e46e                	sd	s11,8(sp)
    800030c0:	1880                	addi	s0,sp,112
    800030c2:	8baa                	mv	s7,a0
    800030c4:	8c2e                	mv	s8,a1
    800030c6:	8ab2                	mv	s5,a2
    800030c8:	84b6                	mv	s1,a3
    800030ca:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800030cc:	9f35                	addw	a4,a4,a3
    return 0;
    800030ce:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800030d0:	0ad76063          	bltu	a4,a3,80003170 <readi+0xd2>
  if(off + n > ip->size)
    800030d4:	00e7f463          	bgeu	a5,a4,800030dc <readi+0x3e>
    n = ip->size - off;
    800030d8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030dc:	0a0b0963          	beqz	s6,8000318e <readi+0xf0>
    800030e0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030e2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030e6:	5cfd                	li	s9,-1
    800030e8:	a82d                	j	80003122 <readi+0x84>
    800030ea:	020a1d93          	slli	s11,s4,0x20
    800030ee:	020ddd93          	srli	s11,s11,0x20
    800030f2:	05890613          	addi	a2,s2,88
    800030f6:	86ee                	mv	a3,s11
    800030f8:	963a                	add	a2,a2,a4
    800030fa:	85d6                	mv	a1,s5
    800030fc:	8562                	mv	a0,s8
    800030fe:	fffff097          	auipc	ra,0xfffff
    80003102:	9cc080e7          	jalr	-1588(ra) # 80001aca <either_copyout>
    80003106:	05950d63          	beq	a0,s9,80003160 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000310a:	854a                	mv	a0,s2
    8000310c:	fffff097          	auipc	ra,0xfffff
    80003110:	60c080e7          	jalr	1548(ra) # 80002718 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003114:	013a09bb          	addw	s3,s4,s3
    80003118:	009a04bb          	addw	s1,s4,s1
    8000311c:	9aee                	add	s5,s5,s11
    8000311e:	0569f763          	bgeu	s3,s6,8000316c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003122:	000ba903          	lw	s2,0(s7)
    80003126:	00a4d59b          	srliw	a1,s1,0xa
    8000312a:	855e                	mv	a0,s7
    8000312c:	00000097          	auipc	ra,0x0
    80003130:	8b0080e7          	jalr	-1872(ra) # 800029dc <bmap>
    80003134:	0005059b          	sext.w	a1,a0
    80003138:	854a                	mv	a0,s2
    8000313a:	fffff097          	auipc	ra,0xfffff
    8000313e:	4ae080e7          	jalr	1198(ra) # 800025e8 <bread>
    80003142:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003144:	3ff4f713          	andi	a4,s1,1023
    80003148:	40ed07bb          	subw	a5,s10,a4
    8000314c:	413b06bb          	subw	a3,s6,s3
    80003150:	8a3e                	mv	s4,a5
    80003152:	2781                	sext.w	a5,a5
    80003154:	0006861b          	sext.w	a2,a3
    80003158:	f8f679e3          	bgeu	a2,a5,800030ea <readi+0x4c>
    8000315c:	8a36                	mv	s4,a3
    8000315e:	b771                	j	800030ea <readi+0x4c>
      brelse(bp);
    80003160:	854a                	mv	a0,s2
    80003162:	fffff097          	auipc	ra,0xfffff
    80003166:	5b6080e7          	jalr	1462(ra) # 80002718 <brelse>
      tot = -1;
    8000316a:	59fd                	li	s3,-1
  }
  return tot;
    8000316c:	0009851b          	sext.w	a0,s3
}
    80003170:	70a6                	ld	ra,104(sp)
    80003172:	7406                	ld	s0,96(sp)
    80003174:	64e6                	ld	s1,88(sp)
    80003176:	6946                	ld	s2,80(sp)
    80003178:	69a6                	ld	s3,72(sp)
    8000317a:	6a06                	ld	s4,64(sp)
    8000317c:	7ae2                	ld	s5,56(sp)
    8000317e:	7b42                	ld	s6,48(sp)
    80003180:	7ba2                	ld	s7,40(sp)
    80003182:	7c02                	ld	s8,32(sp)
    80003184:	6ce2                	ld	s9,24(sp)
    80003186:	6d42                	ld	s10,16(sp)
    80003188:	6da2                	ld	s11,8(sp)
    8000318a:	6165                	addi	sp,sp,112
    8000318c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000318e:	89da                	mv	s3,s6
    80003190:	bff1                	j	8000316c <readi+0xce>
    return 0;
    80003192:	4501                	li	a0,0
}
    80003194:	8082                	ret

0000000080003196 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003196:	457c                	lw	a5,76(a0)
    80003198:	10d7e863          	bltu	a5,a3,800032a8 <writei+0x112>
{
    8000319c:	7159                	addi	sp,sp,-112
    8000319e:	f486                	sd	ra,104(sp)
    800031a0:	f0a2                	sd	s0,96(sp)
    800031a2:	eca6                	sd	s1,88(sp)
    800031a4:	e8ca                	sd	s2,80(sp)
    800031a6:	e4ce                	sd	s3,72(sp)
    800031a8:	e0d2                	sd	s4,64(sp)
    800031aa:	fc56                	sd	s5,56(sp)
    800031ac:	f85a                	sd	s6,48(sp)
    800031ae:	f45e                	sd	s7,40(sp)
    800031b0:	f062                	sd	s8,32(sp)
    800031b2:	ec66                	sd	s9,24(sp)
    800031b4:	e86a                	sd	s10,16(sp)
    800031b6:	e46e                	sd	s11,8(sp)
    800031b8:	1880                	addi	s0,sp,112
    800031ba:	8b2a                	mv	s6,a0
    800031bc:	8c2e                	mv	s8,a1
    800031be:	8ab2                	mv	s5,a2
    800031c0:	8936                	mv	s2,a3
    800031c2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800031c4:	00e687bb          	addw	a5,a3,a4
    800031c8:	0ed7e263          	bltu	a5,a3,800032ac <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800031cc:	00043737          	lui	a4,0x43
    800031d0:	0ef76063          	bltu	a4,a5,800032b0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031d4:	0c0b8863          	beqz	s7,800032a4 <writei+0x10e>
    800031d8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800031da:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800031de:	5cfd                	li	s9,-1
    800031e0:	a091                	j	80003224 <writei+0x8e>
    800031e2:	02099d93          	slli	s11,s3,0x20
    800031e6:	020ddd93          	srli	s11,s11,0x20
    800031ea:	05848513          	addi	a0,s1,88
    800031ee:	86ee                	mv	a3,s11
    800031f0:	8656                	mv	a2,s5
    800031f2:	85e2                	mv	a1,s8
    800031f4:	953a                	add	a0,a0,a4
    800031f6:	fffff097          	auipc	ra,0xfffff
    800031fa:	92a080e7          	jalr	-1750(ra) # 80001b20 <either_copyin>
    800031fe:	07950263          	beq	a0,s9,80003262 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003202:	8526                	mv	a0,s1
    80003204:	00000097          	auipc	ra,0x0
    80003208:	790080e7          	jalr	1936(ra) # 80003994 <log_write>
    brelse(bp);
    8000320c:	8526                	mv	a0,s1
    8000320e:	fffff097          	auipc	ra,0xfffff
    80003212:	50a080e7          	jalr	1290(ra) # 80002718 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003216:	01498a3b          	addw	s4,s3,s4
    8000321a:	0129893b          	addw	s2,s3,s2
    8000321e:	9aee                	add	s5,s5,s11
    80003220:	057a7663          	bgeu	s4,s7,8000326c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003224:	000b2483          	lw	s1,0(s6)
    80003228:	00a9559b          	srliw	a1,s2,0xa
    8000322c:	855a                	mv	a0,s6
    8000322e:	fffff097          	auipc	ra,0xfffff
    80003232:	7ae080e7          	jalr	1966(ra) # 800029dc <bmap>
    80003236:	0005059b          	sext.w	a1,a0
    8000323a:	8526                	mv	a0,s1
    8000323c:	fffff097          	auipc	ra,0xfffff
    80003240:	3ac080e7          	jalr	940(ra) # 800025e8 <bread>
    80003244:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003246:	3ff97713          	andi	a4,s2,1023
    8000324a:	40ed07bb          	subw	a5,s10,a4
    8000324e:	414b86bb          	subw	a3,s7,s4
    80003252:	89be                	mv	s3,a5
    80003254:	2781                	sext.w	a5,a5
    80003256:	0006861b          	sext.w	a2,a3
    8000325a:	f8f674e3          	bgeu	a2,a5,800031e2 <writei+0x4c>
    8000325e:	89b6                	mv	s3,a3
    80003260:	b749                	j	800031e2 <writei+0x4c>
      brelse(bp);
    80003262:	8526                	mv	a0,s1
    80003264:	fffff097          	auipc	ra,0xfffff
    80003268:	4b4080e7          	jalr	1204(ra) # 80002718 <brelse>
  }

  if(off > ip->size)
    8000326c:	04cb2783          	lw	a5,76(s6)
    80003270:	0127f463          	bgeu	a5,s2,80003278 <writei+0xe2>
    ip->size = off;
    80003274:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003278:	855a                	mv	a0,s6
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	aa6080e7          	jalr	-1370(ra) # 80002d20 <iupdate>

  return tot;
    80003282:	000a051b          	sext.w	a0,s4
}
    80003286:	70a6                	ld	ra,104(sp)
    80003288:	7406                	ld	s0,96(sp)
    8000328a:	64e6                	ld	s1,88(sp)
    8000328c:	6946                	ld	s2,80(sp)
    8000328e:	69a6                	ld	s3,72(sp)
    80003290:	6a06                	ld	s4,64(sp)
    80003292:	7ae2                	ld	s5,56(sp)
    80003294:	7b42                	ld	s6,48(sp)
    80003296:	7ba2                	ld	s7,40(sp)
    80003298:	7c02                	ld	s8,32(sp)
    8000329a:	6ce2                	ld	s9,24(sp)
    8000329c:	6d42                	ld	s10,16(sp)
    8000329e:	6da2                	ld	s11,8(sp)
    800032a0:	6165                	addi	sp,sp,112
    800032a2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032a4:	8a5e                	mv	s4,s7
    800032a6:	bfc9                	j	80003278 <writei+0xe2>
    return -1;
    800032a8:	557d                	li	a0,-1
}
    800032aa:	8082                	ret
    return -1;
    800032ac:	557d                	li	a0,-1
    800032ae:	bfe1                	j	80003286 <writei+0xf0>
    return -1;
    800032b0:	557d                	li	a0,-1
    800032b2:	bfd1                	j	80003286 <writei+0xf0>

00000000800032b4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800032b4:	1141                	addi	sp,sp,-16
    800032b6:	e406                	sd	ra,8(sp)
    800032b8:	e022                	sd	s0,0(sp)
    800032ba:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800032bc:	4639                	li	a2,14
    800032be:	ffffd097          	auipc	ra,0xffffd
    800032c2:	f92080e7          	jalr	-110(ra) # 80000250 <strncmp>
}
    800032c6:	60a2                	ld	ra,8(sp)
    800032c8:	6402                	ld	s0,0(sp)
    800032ca:	0141                	addi	sp,sp,16
    800032cc:	8082                	ret

00000000800032ce <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800032ce:	7139                	addi	sp,sp,-64
    800032d0:	fc06                	sd	ra,56(sp)
    800032d2:	f822                	sd	s0,48(sp)
    800032d4:	f426                	sd	s1,40(sp)
    800032d6:	f04a                	sd	s2,32(sp)
    800032d8:	ec4e                	sd	s3,24(sp)
    800032da:	e852                	sd	s4,16(sp)
    800032dc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800032de:	04451703          	lh	a4,68(a0)
    800032e2:	4785                	li	a5,1
    800032e4:	00f71a63          	bne	a4,a5,800032f8 <dirlookup+0x2a>
    800032e8:	892a                	mv	s2,a0
    800032ea:	89ae                	mv	s3,a1
    800032ec:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ee:	457c                	lw	a5,76(a0)
    800032f0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032f2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032f4:	e79d                	bnez	a5,80003322 <dirlookup+0x54>
    800032f6:	a8a5                	j	8000336e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032f8:	00005517          	auipc	a0,0x5
    800032fc:	26850513          	addi	a0,a0,616 # 80008560 <syscalls+0x1b0>
    80003300:	00003097          	auipc	ra,0x3
    80003304:	fd8080e7          	jalr	-40(ra) # 800062d8 <panic>
      panic("dirlookup read");
    80003308:	00005517          	auipc	a0,0x5
    8000330c:	27050513          	addi	a0,a0,624 # 80008578 <syscalls+0x1c8>
    80003310:	00003097          	auipc	ra,0x3
    80003314:	fc8080e7          	jalr	-56(ra) # 800062d8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003318:	24c1                	addiw	s1,s1,16
    8000331a:	04c92783          	lw	a5,76(s2)
    8000331e:	04f4f763          	bgeu	s1,a5,8000336c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003322:	4741                	li	a4,16
    80003324:	86a6                	mv	a3,s1
    80003326:	fc040613          	addi	a2,s0,-64
    8000332a:	4581                	li	a1,0
    8000332c:	854a                	mv	a0,s2
    8000332e:	00000097          	auipc	ra,0x0
    80003332:	d70080e7          	jalr	-656(ra) # 8000309e <readi>
    80003336:	47c1                	li	a5,16
    80003338:	fcf518e3          	bne	a0,a5,80003308 <dirlookup+0x3a>
    if(de.inum == 0)
    8000333c:	fc045783          	lhu	a5,-64(s0)
    80003340:	dfe1                	beqz	a5,80003318 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003342:	fc240593          	addi	a1,s0,-62
    80003346:	854e                	mv	a0,s3
    80003348:	00000097          	auipc	ra,0x0
    8000334c:	f6c080e7          	jalr	-148(ra) # 800032b4 <namecmp>
    80003350:	f561                	bnez	a0,80003318 <dirlookup+0x4a>
      if(poff)
    80003352:	000a0463          	beqz	s4,8000335a <dirlookup+0x8c>
        *poff = off;
    80003356:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000335a:	fc045583          	lhu	a1,-64(s0)
    8000335e:	00092503          	lw	a0,0(s2)
    80003362:	fffff097          	auipc	ra,0xfffff
    80003366:	754080e7          	jalr	1876(ra) # 80002ab6 <iget>
    8000336a:	a011                	j	8000336e <dirlookup+0xa0>
  return 0;
    8000336c:	4501                	li	a0,0
}
    8000336e:	70e2                	ld	ra,56(sp)
    80003370:	7442                	ld	s0,48(sp)
    80003372:	74a2                	ld	s1,40(sp)
    80003374:	7902                	ld	s2,32(sp)
    80003376:	69e2                	ld	s3,24(sp)
    80003378:	6a42                	ld	s4,16(sp)
    8000337a:	6121                	addi	sp,sp,64
    8000337c:	8082                	ret

000000008000337e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000337e:	711d                	addi	sp,sp,-96
    80003380:	ec86                	sd	ra,88(sp)
    80003382:	e8a2                	sd	s0,80(sp)
    80003384:	e4a6                	sd	s1,72(sp)
    80003386:	e0ca                	sd	s2,64(sp)
    80003388:	fc4e                	sd	s3,56(sp)
    8000338a:	f852                	sd	s4,48(sp)
    8000338c:	f456                	sd	s5,40(sp)
    8000338e:	f05a                	sd	s6,32(sp)
    80003390:	ec5e                	sd	s7,24(sp)
    80003392:	e862                	sd	s8,16(sp)
    80003394:	e466                	sd	s9,8(sp)
    80003396:	1080                	addi	s0,sp,96
    80003398:	84aa                	mv	s1,a0
    8000339a:	8b2e                	mv	s6,a1
    8000339c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000339e:	00054703          	lbu	a4,0(a0)
    800033a2:	02f00793          	li	a5,47
    800033a6:	02f70363          	beq	a4,a5,800033cc <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800033aa:	ffffe097          	auipc	ra,0xffffe
    800033ae:	ad2080e7          	jalr	-1326(ra) # 80000e7c <myproc>
    800033b2:	15053503          	ld	a0,336(a0)
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	9f6080e7          	jalr	-1546(ra) # 80002dac <idup>
    800033be:	89aa                	mv	s3,a0
  while(*path == '/')
    800033c0:	02f00913          	li	s2,47
  len = path - s;
    800033c4:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800033c6:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800033c8:	4c05                	li	s8,1
    800033ca:	a865                	j	80003482 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800033cc:	4585                	li	a1,1
    800033ce:	4505                	li	a0,1
    800033d0:	fffff097          	auipc	ra,0xfffff
    800033d4:	6e6080e7          	jalr	1766(ra) # 80002ab6 <iget>
    800033d8:	89aa                	mv	s3,a0
    800033da:	b7dd                	j	800033c0 <namex+0x42>
      iunlockput(ip);
    800033dc:	854e                	mv	a0,s3
    800033de:	00000097          	auipc	ra,0x0
    800033e2:	c6e080e7          	jalr	-914(ra) # 8000304c <iunlockput>
      return 0;
    800033e6:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033e8:	854e                	mv	a0,s3
    800033ea:	60e6                	ld	ra,88(sp)
    800033ec:	6446                	ld	s0,80(sp)
    800033ee:	64a6                	ld	s1,72(sp)
    800033f0:	6906                	ld	s2,64(sp)
    800033f2:	79e2                	ld	s3,56(sp)
    800033f4:	7a42                	ld	s4,48(sp)
    800033f6:	7aa2                	ld	s5,40(sp)
    800033f8:	7b02                	ld	s6,32(sp)
    800033fa:	6be2                	ld	s7,24(sp)
    800033fc:	6c42                	ld	s8,16(sp)
    800033fe:	6ca2                	ld	s9,8(sp)
    80003400:	6125                	addi	sp,sp,96
    80003402:	8082                	ret
      iunlock(ip);
    80003404:	854e                	mv	a0,s3
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	aa6080e7          	jalr	-1370(ra) # 80002eac <iunlock>
      return ip;
    8000340e:	bfe9                	j	800033e8 <namex+0x6a>
      iunlockput(ip);
    80003410:	854e                	mv	a0,s3
    80003412:	00000097          	auipc	ra,0x0
    80003416:	c3a080e7          	jalr	-966(ra) # 8000304c <iunlockput>
      return 0;
    8000341a:	89d2                	mv	s3,s4
    8000341c:	b7f1                	j	800033e8 <namex+0x6a>
  len = path - s;
    8000341e:	40b48633          	sub	a2,s1,a1
    80003422:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003426:	094cd463          	bge	s9,s4,800034ae <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000342a:	4639                	li	a2,14
    8000342c:	8556                	mv	a0,s5
    8000342e:	ffffd097          	auipc	ra,0xffffd
    80003432:	daa080e7          	jalr	-598(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003436:	0004c783          	lbu	a5,0(s1)
    8000343a:	01279763          	bne	a5,s2,80003448 <namex+0xca>
    path++;
    8000343e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003440:	0004c783          	lbu	a5,0(s1)
    80003444:	ff278de3          	beq	a5,s2,8000343e <namex+0xc0>
    ilock(ip);
    80003448:	854e                	mv	a0,s3
    8000344a:	00000097          	auipc	ra,0x0
    8000344e:	9a0080e7          	jalr	-1632(ra) # 80002dea <ilock>
    if(ip->type != T_DIR){
    80003452:	04499783          	lh	a5,68(s3)
    80003456:	f98793e3          	bne	a5,s8,800033dc <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000345a:	000b0563          	beqz	s6,80003464 <namex+0xe6>
    8000345e:	0004c783          	lbu	a5,0(s1)
    80003462:	d3cd                	beqz	a5,80003404 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003464:	865e                	mv	a2,s7
    80003466:	85d6                	mv	a1,s5
    80003468:	854e                	mv	a0,s3
    8000346a:	00000097          	auipc	ra,0x0
    8000346e:	e64080e7          	jalr	-412(ra) # 800032ce <dirlookup>
    80003472:	8a2a                	mv	s4,a0
    80003474:	dd51                	beqz	a0,80003410 <namex+0x92>
    iunlockput(ip);
    80003476:	854e                	mv	a0,s3
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	bd4080e7          	jalr	-1068(ra) # 8000304c <iunlockput>
    ip = next;
    80003480:	89d2                	mv	s3,s4
  while(*path == '/')
    80003482:	0004c783          	lbu	a5,0(s1)
    80003486:	05279763          	bne	a5,s2,800034d4 <namex+0x156>
    path++;
    8000348a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000348c:	0004c783          	lbu	a5,0(s1)
    80003490:	ff278de3          	beq	a5,s2,8000348a <namex+0x10c>
  if(*path == 0)
    80003494:	c79d                	beqz	a5,800034c2 <namex+0x144>
    path++;
    80003496:	85a6                	mv	a1,s1
  len = path - s;
    80003498:	8a5e                	mv	s4,s7
    8000349a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000349c:	01278963          	beq	a5,s2,800034ae <namex+0x130>
    800034a0:	dfbd                	beqz	a5,8000341e <namex+0xa0>
    path++;
    800034a2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800034a4:	0004c783          	lbu	a5,0(s1)
    800034a8:	ff279ce3          	bne	a5,s2,800034a0 <namex+0x122>
    800034ac:	bf8d                	j	8000341e <namex+0xa0>
    memmove(name, s, len);
    800034ae:	2601                	sext.w	a2,a2
    800034b0:	8556                	mv	a0,s5
    800034b2:	ffffd097          	auipc	ra,0xffffd
    800034b6:	d26080e7          	jalr	-730(ra) # 800001d8 <memmove>
    name[len] = 0;
    800034ba:	9a56                	add	s4,s4,s5
    800034bc:	000a0023          	sb	zero,0(s4)
    800034c0:	bf9d                	j	80003436 <namex+0xb8>
  if(nameiparent){
    800034c2:	f20b03e3          	beqz	s6,800033e8 <namex+0x6a>
    iput(ip);
    800034c6:	854e                	mv	a0,s3
    800034c8:	00000097          	auipc	ra,0x0
    800034cc:	adc080e7          	jalr	-1316(ra) # 80002fa4 <iput>
    return 0;
    800034d0:	4981                	li	s3,0
    800034d2:	bf19                	j	800033e8 <namex+0x6a>
  if(*path == 0)
    800034d4:	d7fd                	beqz	a5,800034c2 <namex+0x144>
  while(*path != '/' && *path != 0)
    800034d6:	0004c783          	lbu	a5,0(s1)
    800034da:	85a6                	mv	a1,s1
    800034dc:	b7d1                	j	800034a0 <namex+0x122>

00000000800034de <dirlink>:
{
    800034de:	7139                	addi	sp,sp,-64
    800034e0:	fc06                	sd	ra,56(sp)
    800034e2:	f822                	sd	s0,48(sp)
    800034e4:	f426                	sd	s1,40(sp)
    800034e6:	f04a                	sd	s2,32(sp)
    800034e8:	ec4e                	sd	s3,24(sp)
    800034ea:	e852                	sd	s4,16(sp)
    800034ec:	0080                	addi	s0,sp,64
    800034ee:	892a                	mv	s2,a0
    800034f0:	8a2e                	mv	s4,a1
    800034f2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034f4:	4601                	li	a2,0
    800034f6:	00000097          	auipc	ra,0x0
    800034fa:	dd8080e7          	jalr	-552(ra) # 800032ce <dirlookup>
    800034fe:	e93d                	bnez	a0,80003574 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003500:	04c92483          	lw	s1,76(s2)
    80003504:	c49d                	beqz	s1,80003532 <dirlink+0x54>
    80003506:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003508:	4741                	li	a4,16
    8000350a:	86a6                	mv	a3,s1
    8000350c:	fc040613          	addi	a2,s0,-64
    80003510:	4581                	li	a1,0
    80003512:	854a                	mv	a0,s2
    80003514:	00000097          	auipc	ra,0x0
    80003518:	b8a080e7          	jalr	-1142(ra) # 8000309e <readi>
    8000351c:	47c1                	li	a5,16
    8000351e:	06f51163          	bne	a0,a5,80003580 <dirlink+0xa2>
    if(de.inum == 0)
    80003522:	fc045783          	lhu	a5,-64(s0)
    80003526:	c791                	beqz	a5,80003532 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003528:	24c1                	addiw	s1,s1,16
    8000352a:	04c92783          	lw	a5,76(s2)
    8000352e:	fcf4ede3          	bltu	s1,a5,80003508 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003532:	4639                	li	a2,14
    80003534:	85d2                	mv	a1,s4
    80003536:	fc240513          	addi	a0,s0,-62
    8000353a:	ffffd097          	auipc	ra,0xffffd
    8000353e:	d52080e7          	jalr	-686(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003542:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003546:	4741                	li	a4,16
    80003548:	86a6                	mv	a3,s1
    8000354a:	fc040613          	addi	a2,s0,-64
    8000354e:	4581                	li	a1,0
    80003550:	854a                	mv	a0,s2
    80003552:	00000097          	auipc	ra,0x0
    80003556:	c44080e7          	jalr	-956(ra) # 80003196 <writei>
    8000355a:	872a                	mv	a4,a0
    8000355c:	47c1                	li	a5,16
  return 0;
    8000355e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003560:	02f71863          	bne	a4,a5,80003590 <dirlink+0xb2>
}
    80003564:	70e2                	ld	ra,56(sp)
    80003566:	7442                	ld	s0,48(sp)
    80003568:	74a2                	ld	s1,40(sp)
    8000356a:	7902                	ld	s2,32(sp)
    8000356c:	69e2                	ld	s3,24(sp)
    8000356e:	6a42                	ld	s4,16(sp)
    80003570:	6121                	addi	sp,sp,64
    80003572:	8082                	ret
    iput(ip);
    80003574:	00000097          	auipc	ra,0x0
    80003578:	a30080e7          	jalr	-1488(ra) # 80002fa4 <iput>
    return -1;
    8000357c:	557d                	li	a0,-1
    8000357e:	b7dd                	j	80003564 <dirlink+0x86>
      panic("dirlink read");
    80003580:	00005517          	auipc	a0,0x5
    80003584:	00850513          	addi	a0,a0,8 # 80008588 <syscalls+0x1d8>
    80003588:	00003097          	auipc	ra,0x3
    8000358c:	d50080e7          	jalr	-688(ra) # 800062d8 <panic>
    panic("dirlink");
    80003590:	00005517          	auipc	a0,0x5
    80003594:	10850513          	addi	a0,a0,264 # 80008698 <syscalls+0x2e8>
    80003598:	00003097          	auipc	ra,0x3
    8000359c:	d40080e7          	jalr	-704(ra) # 800062d8 <panic>

00000000800035a0 <namei>:

struct inode*
namei(char *path)
{
    800035a0:	1101                	addi	sp,sp,-32
    800035a2:	ec06                	sd	ra,24(sp)
    800035a4:	e822                	sd	s0,16(sp)
    800035a6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800035a8:	fe040613          	addi	a2,s0,-32
    800035ac:	4581                	li	a1,0
    800035ae:	00000097          	auipc	ra,0x0
    800035b2:	dd0080e7          	jalr	-560(ra) # 8000337e <namex>
}
    800035b6:	60e2                	ld	ra,24(sp)
    800035b8:	6442                	ld	s0,16(sp)
    800035ba:	6105                	addi	sp,sp,32
    800035bc:	8082                	ret

00000000800035be <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800035be:	1141                	addi	sp,sp,-16
    800035c0:	e406                	sd	ra,8(sp)
    800035c2:	e022                	sd	s0,0(sp)
    800035c4:	0800                	addi	s0,sp,16
    800035c6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035c8:	4585                	li	a1,1
    800035ca:	00000097          	auipc	ra,0x0
    800035ce:	db4080e7          	jalr	-588(ra) # 8000337e <namex>
}
    800035d2:	60a2                	ld	ra,8(sp)
    800035d4:	6402                	ld	s0,0(sp)
    800035d6:	0141                	addi	sp,sp,16
    800035d8:	8082                	ret

00000000800035da <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800035da:	1101                	addi	sp,sp,-32
    800035dc:	ec06                	sd	ra,24(sp)
    800035de:	e822                	sd	s0,16(sp)
    800035e0:	e426                	sd	s1,8(sp)
    800035e2:	e04a                	sd	s2,0(sp)
    800035e4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035e6:	0001e917          	auipc	s2,0x1e
    800035ea:	a3a90913          	addi	s2,s2,-1478 # 80021020 <log>
    800035ee:	01892583          	lw	a1,24(s2)
    800035f2:	02892503          	lw	a0,40(s2)
    800035f6:	fffff097          	auipc	ra,0xfffff
    800035fa:	ff2080e7          	jalr	-14(ra) # 800025e8 <bread>
    800035fe:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003600:	02c92683          	lw	a3,44(s2)
    80003604:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003606:	02d05763          	blez	a3,80003634 <write_head+0x5a>
    8000360a:	0001e797          	auipc	a5,0x1e
    8000360e:	a4678793          	addi	a5,a5,-1466 # 80021050 <log+0x30>
    80003612:	05c50713          	addi	a4,a0,92
    80003616:	36fd                	addiw	a3,a3,-1
    80003618:	1682                	slli	a3,a3,0x20
    8000361a:	9281                	srli	a3,a3,0x20
    8000361c:	068a                	slli	a3,a3,0x2
    8000361e:	0001e617          	auipc	a2,0x1e
    80003622:	a3660613          	addi	a2,a2,-1482 # 80021054 <log+0x34>
    80003626:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003628:	4390                	lw	a2,0(a5)
    8000362a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000362c:	0791                	addi	a5,a5,4
    8000362e:	0711                	addi	a4,a4,4
    80003630:	fed79ce3          	bne	a5,a3,80003628 <write_head+0x4e>
  }
  bwrite(buf);
    80003634:	8526                	mv	a0,s1
    80003636:	fffff097          	auipc	ra,0xfffff
    8000363a:	0a4080e7          	jalr	164(ra) # 800026da <bwrite>
  brelse(buf);
    8000363e:	8526                	mv	a0,s1
    80003640:	fffff097          	auipc	ra,0xfffff
    80003644:	0d8080e7          	jalr	216(ra) # 80002718 <brelse>
}
    80003648:	60e2                	ld	ra,24(sp)
    8000364a:	6442                	ld	s0,16(sp)
    8000364c:	64a2                	ld	s1,8(sp)
    8000364e:	6902                	ld	s2,0(sp)
    80003650:	6105                	addi	sp,sp,32
    80003652:	8082                	ret

0000000080003654 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003654:	0001e797          	auipc	a5,0x1e
    80003658:	9f87a783          	lw	a5,-1544(a5) # 8002104c <log+0x2c>
    8000365c:	0af05d63          	blez	a5,80003716 <install_trans+0xc2>
{
    80003660:	7139                	addi	sp,sp,-64
    80003662:	fc06                	sd	ra,56(sp)
    80003664:	f822                	sd	s0,48(sp)
    80003666:	f426                	sd	s1,40(sp)
    80003668:	f04a                	sd	s2,32(sp)
    8000366a:	ec4e                	sd	s3,24(sp)
    8000366c:	e852                	sd	s4,16(sp)
    8000366e:	e456                	sd	s5,8(sp)
    80003670:	e05a                	sd	s6,0(sp)
    80003672:	0080                	addi	s0,sp,64
    80003674:	8b2a                	mv	s6,a0
    80003676:	0001ea97          	auipc	s5,0x1e
    8000367a:	9daa8a93          	addi	s5,s5,-1574 # 80021050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000367e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003680:	0001e997          	auipc	s3,0x1e
    80003684:	9a098993          	addi	s3,s3,-1632 # 80021020 <log>
    80003688:	a035                	j	800036b4 <install_trans+0x60>
      bunpin(dbuf);
    8000368a:	8526                	mv	a0,s1
    8000368c:	fffff097          	auipc	ra,0xfffff
    80003690:	166080e7          	jalr	358(ra) # 800027f2 <bunpin>
    brelse(lbuf);
    80003694:	854a                	mv	a0,s2
    80003696:	fffff097          	auipc	ra,0xfffff
    8000369a:	082080e7          	jalr	130(ra) # 80002718 <brelse>
    brelse(dbuf);
    8000369e:	8526                	mv	a0,s1
    800036a0:	fffff097          	auipc	ra,0xfffff
    800036a4:	078080e7          	jalr	120(ra) # 80002718 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a8:	2a05                	addiw	s4,s4,1
    800036aa:	0a91                	addi	s5,s5,4
    800036ac:	02c9a783          	lw	a5,44(s3)
    800036b0:	04fa5963          	bge	s4,a5,80003702 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036b4:	0189a583          	lw	a1,24(s3)
    800036b8:	014585bb          	addw	a1,a1,s4
    800036bc:	2585                	addiw	a1,a1,1
    800036be:	0289a503          	lw	a0,40(s3)
    800036c2:	fffff097          	auipc	ra,0xfffff
    800036c6:	f26080e7          	jalr	-218(ra) # 800025e8 <bread>
    800036ca:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800036cc:	000aa583          	lw	a1,0(s5)
    800036d0:	0289a503          	lw	a0,40(s3)
    800036d4:	fffff097          	auipc	ra,0xfffff
    800036d8:	f14080e7          	jalr	-236(ra) # 800025e8 <bread>
    800036dc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800036de:	40000613          	li	a2,1024
    800036e2:	05890593          	addi	a1,s2,88
    800036e6:	05850513          	addi	a0,a0,88
    800036ea:	ffffd097          	auipc	ra,0xffffd
    800036ee:	aee080e7          	jalr	-1298(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800036f2:	8526                	mv	a0,s1
    800036f4:	fffff097          	auipc	ra,0xfffff
    800036f8:	fe6080e7          	jalr	-26(ra) # 800026da <bwrite>
    if(recovering == 0)
    800036fc:	f80b1ce3          	bnez	s6,80003694 <install_trans+0x40>
    80003700:	b769                	j	8000368a <install_trans+0x36>
}
    80003702:	70e2                	ld	ra,56(sp)
    80003704:	7442                	ld	s0,48(sp)
    80003706:	74a2                	ld	s1,40(sp)
    80003708:	7902                	ld	s2,32(sp)
    8000370a:	69e2                	ld	s3,24(sp)
    8000370c:	6a42                	ld	s4,16(sp)
    8000370e:	6aa2                	ld	s5,8(sp)
    80003710:	6b02                	ld	s6,0(sp)
    80003712:	6121                	addi	sp,sp,64
    80003714:	8082                	ret
    80003716:	8082                	ret

0000000080003718 <initlog>:
{
    80003718:	7179                	addi	sp,sp,-48
    8000371a:	f406                	sd	ra,40(sp)
    8000371c:	f022                	sd	s0,32(sp)
    8000371e:	ec26                	sd	s1,24(sp)
    80003720:	e84a                	sd	s2,16(sp)
    80003722:	e44e                	sd	s3,8(sp)
    80003724:	1800                	addi	s0,sp,48
    80003726:	892a                	mv	s2,a0
    80003728:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000372a:	0001e497          	auipc	s1,0x1e
    8000372e:	8f648493          	addi	s1,s1,-1802 # 80021020 <log>
    80003732:	00005597          	auipc	a1,0x5
    80003736:	e6658593          	addi	a1,a1,-410 # 80008598 <syscalls+0x1e8>
    8000373a:	8526                	mv	a0,s1
    8000373c:	00003097          	auipc	ra,0x3
    80003740:	056080e7          	jalr	86(ra) # 80006792 <initlock>
  log.start = sb->logstart;
    80003744:	0149a583          	lw	a1,20(s3)
    80003748:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000374a:	0109a783          	lw	a5,16(s3)
    8000374e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003750:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003754:	854a                	mv	a0,s2
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	e92080e7          	jalr	-366(ra) # 800025e8 <bread>
  log.lh.n = lh->n;
    8000375e:	4d3c                	lw	a5,88(a0)
    80003760:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003762:	02f05563          	blez	a5,8000378c <initlog+0x74>
    80003766:	05c50713          	addi	a4,a0,92
    8000376a:	0001e697          	auipc	a3,0x1e
    8000376e:	8e668693          	addi	a3,a3,-1818 # 80021050 <log+0x30>
    80003772:	37fd                	addiw	a5,a5,-1
    80003774:	1782                	slli	a5,a5,0x20
    80003776:	9381                	srli	a5,a5,0x20
    80003778:	078a                	slli	a5,a5,0x2
    8000377a:	06050613          	addi	a2,a0,96
    8000377e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003780:	4310                	lw	a2,0(a4)
    80003782:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003784:	0711                	addi	a4,a4,4
    80003786:	0691                	addi	a3,a3,4
    80003788:	fef71ce3          	bne	a4,a5,80003780 <initlog+0x68>
  brelse(buf);
    8000378c:	fffff097          	auipc	ra,0xfffff
    80003790:	f8c080e7          	jalr	-116(ra) # 80002718 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003794:	4505                	li	a0,1
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	ebe080e7          	jalr	-322(ra) # 80003654 <install_trans>
  log.lh.n = 0;
    8000379e:	0001e797          	auipc	a5,0x1e
    800037a2:	8a07a723          	sw	zero,-1874(a5) # 8002104c <log+0x2c>
  write_head(); // clear the log
    800037a6:	00000097          	auipc	ra,0x0
    800037aa:	e34080e7          	jalr	-460(ra) # 800035da <write_head>
}
    800037ae:	70a2                	ld	ra,40(sp)
    800037b0:	7402                	ld	s0,32(sp)
    800037b2:	64e2                	ld	s1,24(sp)
    800037b4:	6942                	ld	s2,16(sp)
    800037b6:	69a2                	ld	s3,8(sp)
    800037b8:	6145                	addi	sp,sp,48
    800037ba:	8082                	ret

00000000800037bc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800037bc:	1101                	addi	sp,sp,-32
    800037be:	ec06                	sd	ra,24(sp)
    800037c0:	e822                	sd	s0,16(sp)
    800037c2:	e426                	sd	s1,8(sp)
    800037c4:	e04a                	sd	s2,0(sp)
    800037c6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037c8:	0001e517          	auipc	a0,0x1e
    800037cc:	85850513          	addi	a0,a0,-1960 # 80021020 <log>
    800037d0:	00003097          	auipc	ra,0x3
    800037d4:	052080e7          	jalr	82(ra) # 80006822 <acquire>
  while(1){
    if(log.committing){
    800037d8:	0001e497          	auipc	s1,0x1e
    800037dc:	84848493          	addi	s1,s1,-1976 # 80021020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037e0:	4979                	li	s2,30
    800037e2:	a039                	j	800037f0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800037e4:	85a6                	mv	a1,s1
    800037e6:	8526                	mv	a0,s1
    800037e8:	ffffe097          	auipc	ra,0xffffe
    800037ec:	d94080e7          	jalr	-620(ra) # 8000157c <sleep>
    if(log.committing){
    800037f0:	50dc                	lw	a5,36(s1)
    800037f2:	fbed                	bnez	a5,800037e4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037f4:	509c                	lw	a5,32(s1)
    800037f6:	0017871b          	addiw	a4,a5,1
    800037fa:	0007069b          	sext.w	a3,a4
    800037fe:	0027179b          	slliw	a5,a4,0x2
    80003802:	9fb9                	addw	a5,a5,a4
    80003804:	0017979b          	slliw	a5,a5,0x1
    80003808:	54d8                	lw	a4,44(s1)
    8000380a:	9fb9                	addw	a5,a5,a4
    8000380c:	00f95963          	bge	s2,a5,8000381e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003810:	85a6                	mv	a1,s1
    80003812:	8526                	mv	a0,s1
    80003814:	ffffe097          	auipc	ra,0xffffe
    80003818:	d68080e7          	jalr	-664(ra) # 8000157c <sleep>
    8000381c:	bfd1                	j	800037f0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000381e:	0001e517          	auipc	a0,0x1e
    80003822:	80250513          	addi	a0,a0,-2046 # 80021020 <log>
    80003826:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003828:	00003097          	auipc	ra,0x3
    8000382c:	0ae080e7          	jalr	174(ra) # 800068d6 <release>
      break;
    }
  }
}
    80003830:	60e2                	ld	ra,24(sp)
    80003832:	6442                	ld	s0,16(sp)
    80003834:	64a2                	ld	s1,8(sp)
    80003836:	6902                	ld	s2,0(sp)
    80003838:	6105                	addi	sp,sp,32
    8000383a:	8082                	ret

000000008000383c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000383c:	7139                	addi	sp,sp,-64
    8000383e:	fc06                	sd	ra,56(sp)
    80003840:	f822                	sd	s0,48(sp)
    80003842:	f426                	sd	s1,40(sp)
    80003844:	f04a                	sd	s2,32(sp)
    80003846:	ec4e                	sd	s3,24(sp)
    80003848:	e852                	sd	s4,16(sp)
    8000384a:	e456                	sd	s5,8(sp)
    8000384c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000384e:	0001d497          	auipc	s1,0x1d
    80003852:	7d248493          	addi	s1,s1,2002 # 80021020 <log>
    80003856:	8526                	mv	a0,s1
    80003858:	00003097          	auipc	ra,0x3
    8000385c:	fca080e7          	jalr	-54(ra) # 80006822 <acquire>
  log.outstanding -= 1;
    80003860:	509c                	lw	a5,32(s1)
    80003862:	37fd                	addiw	a5,a5,-1
    80003864:	0007891b          	sext.w	s2,a5
    80003868:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000386a:	50dc                	lw	a5,36(s1)
    8000386c:	efb9                	bnez	a5,800038ca <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000386e:	06091663          	bnez	s2,800038da <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003872:	0001d497          	auipc	s1,0x1d
    80003876:	7ae48493          	addi	s1,s1,1966 # 80021020 <log>
    8000387a:	4785                	li	a5,1
    8000387c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000387e:	8526                	mv	a0,s1
    80003880:	00003097          	auipc	ra,0x3
    80003884:	056080e7          	jalr	86(ra) # 800068d6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003888:	54dc                	lw	a5,44(s1)
    8000388a:	06f04763          	bgtz	a5,800038f8 <end_op+0xbc>
    acquire(&log.lock);
    8000388e:	0001d497          	auipc	s1,0x1d
    80003892:	79248493          	addi	s1,s1,1938 # 80021020 <log>
    80003896:	8526                	mv	a0,s1
    80003898:	00003097          	auipc	ra,0x3
    8000389c:	f8a080e7          	jalr	-118(ra) # 80006822 <acquire>
    log.committing = 0;
    800038a0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800038a4:	8526                	mv	a0,s1
    800038a6:	ffffe097          	auipc	ra,0xffffe
    800038aa:	e62080e7          	jalr	-414(ra) # 80001708 <wakeup>
    release(&log.lock);
    800038ae:	8526                	mv	a0,s1
    800038b0:	00003097          	auipc	ra,0x3
    800038b4:	026080e7          	jalr	38(ra) # 800068d6 <release>
}
    800038b8:	70e2                	ld	ra,56(sp)
    800038ba:	7442                	ld	s0,48(sp)
    800038bc:	74a2                	ld	s1,40(sp)
    800038be:	7902                	ld	s2,32(sp)
    800038c0:	69e2                	ld	s3,24(sp)
    800038c2:	6a42                	ld	s4,16(sp)
    800038c4:	6aa2                	ld	s5,8(sp)
    800038c6:	6121                	addi	sp,sp,64
    800038c8:	8082                	ret
    panic("log.committing");
    800038ca:	00005517          	auipc	a0,0x5
    800038ce:	cd650513          	addi	a0,a0,-810 # 800085a0 <syscalls+0x1f0>
    800038d2:	00003097          	auipc	ra,0x3
    800038d6:	a06080e7          	jalr	-1530(ra) # 800062d8 <panic>
    wakeup(&log);
    800038da:	0001d497          	auipc	s1,0x1d
    800038de:	74648493          	addi	s1,s1,1862 # 80021020 <log>
    800038e2:	8526                	mv	a0,s1
    800038e4:	ffffe097          	auipc	ra,0xffffe
    800038e8:	e24080e7          	jalr	-476(ra) # 80001708 <wakeup>
  release(&log.lock);
    800038ec:	8526                	mv	a0,s1
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	fe8080e7          	jalr	-24(ra) # 800068d6 <release>
  if(do_commit){
    800038f6:	b7c9                	j	800038b8 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038f8:	0001da97          	auipc	s5,0x1d
    800038fc:	758a8a93          	addi	s5,s5,1880 # 80021050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003900:	0001da17          	auipc	s4,0x1d
    80003904:	720a0a13          	addi	s4,s4,1824 # 80021020 <log>
    80003908:	018a2583          	lw	a1,24(s4)
    8000390c:	012585bb          	addw	a1,a1,s2
    80003910:	2585                	addiw	a1,a1,1
    80003912:	028a2503          	lw	a0,40(s4)
    80003916:	fffff097          	auipc	ra,0xfffff
    8000391a:	cd2080e7          	jalr	-814(ra) # 800025e8 <bread>
    8000391e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003920:	000aa583          	lw	a1,0(s5)
    80003924:	028a2503          	lw	a0,40(s4)
    80003928:	fffff097          	auipc	ra,0xfffff
    8000392c:	cc0080e7          	jalr	-832(ra) # 800025e8 <bread>
    80003930:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003932:	40000613          	li	a2,1024
    80003936:	05850593          	addi	a1,a0,88
    8000393a:	05848513          	addi	a0,s1,88
    8000393e:	ffffd097          	auipc	ra,0xffffd
    80003942:	89a080e7          	jalr	-1894(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003946:	8526                	mv	a0,s1
    80003948:	fffff097          	auipc	ra,0xfffff
    8000394c:	d92080e7          	jalr	-622(ra) # 800026da <bwrite>
    brelse(from);
    80003950:	854e                	mv	a0,s3
    80003952:	fffff097          	auipc	ra,0xfffff
    80003956:	dc6080e7          	jalr	-570(ra) # 80002718 <brelse>
    brelse(to);
    8000395a:	8526                	mv	a0,s1
    8000395c:	fffff097          	auipc	ra,0xfffff
    80003960:	dbc080e7          	jalr	-580(ra) # 80002718 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003964:	2905                	addiw	s2,s2,1
    80003966:	0a91                	addi	s5,s5,4
    80003968:	02ca2783          	lw	a5,44(s4)
    8000396c:	f8f94ee3          	blt	s2,a5,80003908 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003970:	00000097          	auipc	ra,0x0
    80003974:	c6a080e7          	jalr	-918(ra) # 800035da <write_head>
    install_trans(0); // Now install writes to home locations
    80003978:	4501                	li	a0,0
    8000397a:	00000097          	auipc	ra,0x0
    8000397e:	cda080e7          	jalr	-806(ra) # 80003654 <install_trans>
    log.lh.n = 0;
    80003982:	0001d797          	auipc	a5,0x1d
    80003986:	6c07a523          	sw	zero,1738(a5) # 8002104c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000398a:	00000097          	auipc	ra,0x0
    8000398e:	c50080e7          	jalr	-944(ra) # 800035da <write_head>
    80003992:	bdf5                	j	8000388e <end_op+0x52>

0000000080003994 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003994:	1101                	addi	sp,sp,-32
    80003996:	ec06                	sd	ra,24(sp)
    80003998:	e822                	sd	s0,16(sp)
    8000399a:	e426                	sd	s1,8(sp)
    8000399c:	e04a                	sd	s2,0(sp)
    8000399e:	1000                	addi	s0,sp,32
    800039a0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039a2:	0001d917          	auipc	s2,0x1d
    800039a6:	67e90913          	addi	s2,s2,1662 # 80021020 <log>
    800039aa:	854a                	mv	a0,s2
    800039ac:	00003097          	auipc	ra,0x3
    800039b0:	e76080e7          	jalr	-394(ra) # 80006822 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039b4:	02c92603          	lw	a2,44(s2)
    800039b8:	47f5                	li	a5,29
    800039ba:	06c7c563          	blt	a5,a2,80003a24 <log_write+0x90>
    800039be:	0001d797          	auipc	a5,0x1d
    800039c2:	67e7a783          	lw	a5,1662(a5) # 8002103c <log+0x1c>
    800039c6:	37fd                	addiw	a5,a5,-1
    800039c8:	04f65e63          	bge	a2,a5,80003a24 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800039cc:	0001d797          	auipc	a5,0x1d
    800039d0:	6747a783          	lw	a5,1652(a5) # 80021040 <log+0x20>
    800039d4:	06f05063          	blez	a5,80003a34 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800039d8:	4781                	li	a5,0
    800039da:	06c05563          	blez	a2,80003a44 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039de:	44cc                	lw	a1,12(s1)
    800039e0:	0001d717          	auipc	a4,0x1d
    800039e4:	67070713          	addi	a4,a4,1648 # 80021050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800039e8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039ea:	4314                	lw	a3,0(a4)
    800039ec:	04b68c63          	beq	a3,a1,80003a44 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039f0:	2785                	addiw	a5,a5,1
    800039f2:	0711                	addi	a4,a4,4
    800039f4:	fef61be3          	bne	a2,a5,800039ea <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039f8:	0621                	addi	a2,a2,8
    800039fa:	060a                	slli	a2,a2,0x2
    800039fc:	0001d797          	auipc	a5,0x1d
    80003a00:	62478793          	addi	a5,a5,1572 # 80021020 <log>
    80003a04:	963e                	add	a2,a2,a5
    80003a06:	44dc                	lw	a5,12(s1)
    80003a08:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	fffff097          	auipc	ra,0xfffff
    80003a10:	daa080e7          	jalr	-598(ra) # 800027b6 <bpin>
    log.lh.n++;
    80003a14:	0001d717          	auipc	a4,0x1d
    80003a18:	60c70713          	addi	a4,a4,1548 # 80021020 <log>
    80003a1c:	575c                	lw	a5,44(a4)
    80003a1e:	2785                	addiw	a5,a5,1
    80003a20:	d75c                	sw	a5,44(a4)
    80003a22:	a835                	j	80003a5e <log_write+0xca>
    panic("too big a transaction");
    80003a24:	00005517          	auipc	a0,0x5
    80003a28:	b8c50513          	addi	a0,a0,-1140 # 800085b0 <syscalls+0x200>
    80003a2c:	00003097          	auipc	ra,0x3
    80003a30:	8ac080e7          	jalr	-1876(ra) # 800062d8 <panic>
    panic("log_write outside of trans");
    80003a34:	00005517          	auipc	a0,0x5
    80003a38:	b9450513          	addi	a0,a0,-1132 # 800085c8 <syscalls+0x218>
    80003a3c:	00003097          	auipc	ra,0x3
    80003a40:	89c080e7          	jalr	-1892(ra) # 800062d8 <panic>
  log.lh.block[i] = b->blockno;
    80003a44:	00878713          	addi	a4,a5,8
    80003a48:	00271693          	slli	a3,a4,0x2
    80003a4c:	0001d717          	auipc	a4,0x1d
    80003a50:	5d470713          	addi	a4,a4,1492 # 80021020 <log>
    80003a54:	9736                	add	a4,a4,a3
    80003a56:	44d4                	lw	a3,12(s1)
    80003a58:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a5a:	faf608e3          	beq	a2,a5,80003a0a <log_write+0x76>
  }
  release(&log.lock);
    80003a5e:	0001d517          	auipc	a0,0x1d
    80003a62:	5c250513          	addi	a0,a0,1474 # 80021020 <log>
    80003a66:	00003097          	auipc	ra,0x3
    80003a6a:	e70080e7          	jalr	-400(ra) # 800068d6 <release>
}
    80003a6e:	60e2                	ld	ra,24(sp)
    80003a70:	6442                	ld	s0,16(sp)
    80003a72:	64a2                	ld	s1,8(sp)
    80003a74:	6902                	ld	s2,0(sp)
    80003a76:	6105                	addi	sp,sp,32
    80003a78:	8082                	ret

0000000080003a7a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a7a:	1101                	addi	sp,sp,-32
    80003a7c:	ec06                	sd	ra,24(sp)
    80003a7e:	e822                	sd	s0,16(sp)
    80003a80:	e426                	sd	s1,8(sp)
    80003a82:	e04a                	sd	s2,0(sp)
    80003a84:	1000                	addi	s0,sp,32
    80003a86:	84aa                	mv	s1,a0
    80003a88:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a8a:	00005597          	auipc	a1,0x5
    80003a8e:	b5e58593          	addi	a1,a1,-1186 # 800085e8 <syscalls+0x238>
    80003a92:	0521                	addi	a0,a0,8
    80003a94:	00003097          	auipc	ra,0x3
    80003a98:	cfe080e7          	jalr	-770(ra) # 80006792 <initlock>
  lk->name = name;
    80003a9c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003aa0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aa4:	0204a423          	sw	zero,40(s1)
}
    80003aa8:	60e2                	ld	ra,24(sp)
    80003aaa:	6442                	ld	s0,16(sp)
    80003aac:	64a2                	ld	s1,8(sp)
    80003aae:	6902                	ld	s2,0(sp)
    80003ab0:	6105                	addi	sp,sp,32
    80003ab2:	8082                	ret

0000000080003ab4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ab4:	1101                	addi	sp,sp,-32
    80003ab6:	ec06                	sd	ra,24(sp)
    80003ab8:	e822                	sd	s0,16(sp)
    80003aba:	e426                	sd	s1,8(sp)
    80003abc:	e04a                	sd	s2,0(sp)
    80003abe:	1000                	addi	s0,sp,32
    80003ac0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ac2:	00850913          	addi	s2,a0,8
    80003ac6:	854a                	mv	a0,s2
    80003ac8:	00003097          	auipc	ra,0x3
    80003acc:	d5a080e7          	jalr	-678(ra) # 80006822 <acquire>
  while (lk->locked) {
    80003ad0:	409c                	lw	a5,0(s1)
    80003ad2:	cb89                	beqz	a5,80003ae4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003ad4:	85ca                	mv	a1,s2
    80003ad6:	8526                	mv	a0,s1
    80003ad8:	ffffe097          	auipc	ra,0xffffe
    80003adc:	aa4080e7          	jalr	-1372(ra) # 8000157c <sleep>
  while (lk->locked) {
    80003ae0:	409c                	lw	a5,0(s1)
    80003ae2:	fbed                	bnez	a5,80003ad4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003ae4:	4785                	li	a5,1
    80003ae6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ae8:	ffffd097          	auipc	ra,0xffffd
    80003aec:	394080e7          	jalr	916(ra) # 80000e7c <myproc>
    80003af0:	591c                	lw	a5,48(a0)
    80003af2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003af4:	854a                	mv	a0,s2
    80003af6:	00003097          	auipc	ra,0x3
    80003afa:	de0080e7          	jalr	-544(ra) # 800068d6 <release>
}
    80003afe:	60e2                	ld	ra,24(sp)
    80003b00:	6442                	ld	s0,16(sp)
    80003b02:	64a2                	ld	s1,8(sp)
    80003b04:	6902                	ld	s2,0(sp)
    80003b06:	6105                	addi	sp,sp,32
    80003b08:	8082                	ret

0000000080003b0a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b0a:	1101                	addi	sp,sp,-32
    80003b0c:	ec06                	sd	ra,24(sp)
    80003b0e:	e822                	sd	s0,16(sp)
    80003b10:	e426                	sd	s1,8(sp)
    80003b12:	e04a                	sd	s2,0(sp)
    80003b14:	1000                	addi	s0,sp,32
    80003b16:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b18:	00850913          	addi	s2,a0,8
    80003b1c:	854a                	mv	a0,s2
    80003b1e:	00003097          	auipc	ra,0x3
    80003b22:	d04080e7          	jalr	-764(ra) # 80006822 <acquire>
  lk->locked = 0;
    80003b26:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b2a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b2e:	8526                	mv	a0,s1
    80003b30:	ffffe097          	auipc	ra,0xffffe
    80003b34:	bd8080e7          	jalr	-1064(ra) # 80001708 <wakeup>
  release(&lk->lk);
    80003b38:	854a                	mv	a0,s2
    80003b3a:	00003097          	auipc	ra,0x3
    80003b3e:	d9c080e7          	jalr	-612(ra) # 800068d6 <release>
}
    80003b42:	60e2                	ld	ra,24(sp)
    80003b44:	6442                	ld	s0,16(sp)
    80003b46:	64a2                	ld	s1,8(sp)
    80003b48:	6902                	ld	s2,0(sp)
    80003b4a:	6105                	addi	sp,sp,32
    80003b4c:	8082                	ret

0000000080003b4e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b4e:	7179                	addi	sp,sp,-48
    80003b50:	f406                	sd	ra,40(sp)
    80003b52:	f022                	sd	s0,32(sp)
    80003b54:	ec26                	sd	s1,24(sp)
    80003b56:	e84a                	sd	s2,16(sp)
    80003b58:	e44e                	sd	s3,8(sp)
    80003b5a:	1800                	addi	s0,sp,48
    80003b5c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b5e:	00850913          	addi	s2,a0,8
    80003b62:	854a                	mv	a0,s2
    80003b64:	00003097          	auipc	ra,0x3
    80003b68:	cbe080e7          	jalr	-834(ra) # 80006822 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b6c:	409c                	lw	a5,0(s1)
    80003b6e:	ef99                	bnez	a5,80003b8c <holdingsleep+0x3e>
    80003b70:	4481                	li	s1,0
  release(&lk->lk);
    80003b72:	854a                	mv	a0,s2
    80003b74:	00003097          	auipc	ra,0x3
    80003b78:	d62080e7          	jalr	-670(ra) # 800068d6 <release>
  return r;
}
    80003b7c:	8526                	mv	a0,s1
    80003b7e:	70a2                	ld	ra,40(sp)
    80003b80:	7402                	ld	s0,32(sp)
    80003b82:	64e2                	ld	s1,24(sp)
    80003b84:	6942                	ld	s2,16(sp)
    80003b86:	69a2                	ld	s3,8(sp)
    80003b88:	6145                	addi	sp,sp,48
    80003b8a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b8c:	0284a983          	lw	s3,40(s1)
    80003b90:	ffffd097          	auipc	ra,0xffffd
    80003b94:	2ec080e7          	jalr	748(ra) # 80000e7c <myproc>
    80003b98:	5904                	lw	s1,48(a0)
    80003b9a:	413484b3          	sub	s1,s1,s3
    80003b9e:	0014b493          	seqz	s1,s1
    80003ba2:	bfc1                	j	80003b72 <holdingsleep+0x24>

0000000080003ba4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ba4:	1141                	addi	sp,sp,-16
    80003ba6:	e406                	sd	ra,8(sp)
    80003ba8:	e022                	sd	s0,0(sp)
    80003baa:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003bac:	00005597          	auipc	a1,0x5
    80003bb0:	a4c58593          	addi	a1,a1,-1460 # 800085f8 <syscalls+0x248>
    80003bb4:	0001d517          	auipc	a0,0x1d
    80003bb8:	5b450513          	addi	a0,a0,1460 # 80021168 <ftable>
    80003bbc:	00003097          	auipc	ra,0x3
    80003bc0:	bd6080e7          	jalr	-1066(ra) # 80006792 <initlock>
}
    80003bc4:	60a2                	ld	ra,8(sp)
    80003bc6:	6402                	ld	s0,0(sp)
    80003bc8:	0141                	addi	sp,sp,16
    80003bca:	8082                	ret

0000000080003bcc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003bcc:	1101                	addi	sp,sp,-32
    80003bce:	ec06                	sd	ra,24(sp)
    80003bd0:	e822                	sd	s0,16(sp)
    80003bd2:	e426                	sd	s1,8(sp)
    80003bd4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003bd6:	0001d517          	auipc	a0,0x1d
    80003bda:	59250513          	addi	a0,a0,1426 # 80021168 <ftable>
    80003bde:	00003097          	auipc	ra,0x3
    80003be2:	c44080e7          	jalr	-956(ra) # 80006822 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003be6:	0001d497          	auipc	s1,0x1d
    80003bea:	59a48493          	addi	s1,s1,1434 # 80021180 <ftable+0x18>
    80003bee:	0001e717          	auipc	a4,0x1e
    80003bf2:	53270713          	addi	a4,a4,1330 # 80022120 <ftable+0xfb8>
    if(f->ref == 0){
    80003bf6:	40dc                	lw	a5,4(s1)
    80003bf8:	cf99                	beqz	a5,80003c16 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bfa:	02848493          	addi	s1,s1,40
    80003bfe:	fee49ce3          	bne	s1,a4,80003bf6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c02:	0001d517          	auipc	a0,0x1d
    80003c06:	56650513          	addi	a0,a0,1382 # 80021168 <ftable>
    80003c0a:	00003097          	auipc	ra,0x3
    80003c0e:	ccc080e7          	jalr	-820(ra) # 800068d6 <release>
  return 0;
    80003c12:	4481                	li	s1,0
    80003c14:	a819                	j	80003c2a <filealloc+0x5e>
      f->ref = 1;
    80003c16:	4785                	li	a5,1
    80003c18:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c1a:	0001d517          	auipc	a0,0x1d
    80003c1e:	54e50513          	addi	a0,a0,1358 # 80021168 <ftable>
    80003c22:	00003097          	auipc	ra,0x3
    80003c26:	cb4080e7          	jalr	-844(ra) # 800068d6 <release>
}
    80003c2a:	8526                	mv	a0,s1
    80003c2c:	60e2                	ld	ra,24(sp)
    80003c2e:	6442                	ld	s0,16(sp)
    80003c30:	64a2                	ld	s1,8(sp)
    80003c32:	6105                	addi	sp,sp,32
    80003c34:	8082                	ret

0000000080003c36 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c36:	1101                	addi	sp,sp,-32
    80003c38:	ec06                	sd	ra,24(sp)
    80003c3a:	e822                	sd	s0,16(sp)
    80003c3c:	e426                	sd	s1,8(sp)
    80003c3e:	1000                	addi	s0,sp,32
    80003c40:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c42:	0001d517          	auipc	a0,0x1d
    80003c46:	52650513          	addi	a0,a0,1318 # 80021168 <ftable>
    80003c4a:	00003097          	auipc	ra,0x3
    80003c4e:	bd8080e7          	jalr	-1064(ra) # 80006822 <acquire>
  if(f->ref < 1)
    80003c52:	40dc                	lw	a5,4(s1)
    80003c54:	02f05263          	blez	a5,80003c78 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c58:	2785                	addiw	a5,a5,1
    80003c5a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c5c:	0001d517          	auipc	a0,0x1d
    80003c60:	50c50513          	addi	a0,a0,1292 # 80021168 <ftable>
    80003c64:	00003097          	auipc	ra,0x3
    80003c68:	c72080e7          	jalr	-910(ra) # 800068d6 <release>
  return f;
}
    80003c6c:	8526                	mv	a0,s1
    80003c6e:	60e2                	ld	ra,24(sp)
    80003c70:	6442                	ld	s0,16(sp)
    80003c72:	64a2                	ld	s1,8(sp)
    80003c74:	6105                	addi	sp,sp,32
    80003c76:	8082                	ret
    panic("filedup");
    80003c78:	00005517          	auipc	a0,0x5
    80003c7c:	98850513          	addi	a0,a0,-1656 # 80008600 <syscalls+0x250>
    80003c80:	00002097          	auipc	ra,0x2
    80003c84:	658080e7          	jalr	1624(ra) # 800062d8 <panic>

0000000080003c88 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c88:	7139                	addi	sp,sp,-64
    80003c8a:	fc06                	sd	ra,56(sp)
    80003c8c:	f822                	sd	s0,48(sp)
    80003c8e:	f426                	sd	s1,40(sp)
    80003c90:	f04a                	sd	s2,32(sp)
    80003c92:	ec4e                	sd	s3,24(sp)
    80003c94:	e852                	sd	s4,16(sp)
    80003c96:	e456                	sd	s5,8(sp)
    80003c98:	0080                	addi	s0,sp,64
    80003c9a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c9c:	0001d517          	auipc	a0,0x1d
    80003ca0:	4cc50513          	addi	a0,a0,1228 # 80021168 <ftable>
    80003ca4:	00003097          	auipc	ra,0x3
    80003ca8:	b7e080e7          	jalr	-1154(ra) # 80006822 <acquire>
  if(f->ref < 1)
    80003cac:	40dc                	lw	a5,4(s1)
    80003cae:	06f05163          	blez	a5,80003d10 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003cb2:	37fd                	addiw	a5,a5,-1
    80003cb4:	0007871b          	sext.w	a4,a5
    80003cb8:	c0dc                	sw	a5,4(s1)
    80003cba:	06e04363          	bgtz	a4,80003d20 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003cbe:	0004a903          	lw	s2,0(s1)
    80003cc2:	0094ca83          	lbu	s5,9(s1)
    80003cc6:	0104ba03          	ld	s4,16(s1)
    80003cca:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003cce:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003cd2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003cd6:	0001d517          	auipc	a0,0x1d
    80003cda:	49250513          	addi	a0,a0,1170 # 80021168 <ftable>
    80003cde:	00003097          	auipc	ra,0x3
    80003ce2:	bf8080e7          	jalr	-1032(ra) # 800068d6 <release>

  if(ff.type == FD_PIPE){
    80003ce6:	4785                	li	a5,1
    80003ce8:	04f90d63          	beq	s2,a5,80003d42 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003cec:	3979                	addiw	s2,s2,-2
    80003cee:	4785                	li	a5,1
    80003cf0:	0527e063          	bltu	a5,s2,80003d30 <fileclose+0xa8>
    begin_op();
    80003cf4:	00000097          	auipc	ra,0x0
    80003cf8:	ac8080e7          	jalr	-1336(ra) # 800037bc <begin_op>
    iput(ff.ip);
    80003cfc:	854e                	mv	a0,s3
    80003cfe:	fffff097          	auipc	ra,0xfffff
    80003d02:	2a6080e7          	jalr	678(ra) # 80002fa4 <iput>
    end_op();
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	b36080e7          	jalr	-1226(ra) # 8000383c <end_op>
    80003d0e:	a00d                	j	80003d30 <fileclose+0xa8>
    panic("fileclose");
    80003d10:	00005517          	auipc	a0,0x5
    80003d14:	8f850513          	addi	a0,a0,-1800 # 80008608 <syscalls+0x258>
    80003d18:	00002097          	auipc	ra,0x2
    80003d1c:	5c0080e7          	jalr	1472(ra) # 800062d8 <panic>
    release(&ftable.lock);
    80003d20:	0001d517          	auipc	a0,0x1d
    80003d24:	44850513          	addi	a0,a0,1096 # 80021168 <ftable>
    80003d28:	00003097          	auipc	ra,0x3
    80003d2c:	bae080e7          	jalr	-1106(ra) # 800068d6 <release>
  }
}
    80003d30:	70e2                	ld	ra,56(sp)
    80003d32:	7442                	ld	s0,48(sp)
    80003d34:	74a2                	ld	s1,40(sp)
    80003d36:	7902                	ld	s2,32(sp)
    80003d38:	69e2                	ld	s3,24(sp)
    80003d3a:	6a42                	ld	s4,16(sp)
    80003d3c:	6aa2                	ld	s5,8(sp)
    80003d3e:	6121                	addi	sp,sp,64
    80003d40:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d42:	85d6                	mv	a1,s5
    80003d44:	8552                	mv	a0,s4
    80003d46:	00000097          	auipc	ra,0x0
    80003d4a:	34c080e7          	jalr	844(ra) # 80004092 <pipeclose>
    80003d4e:	b7cd                	j	80003d30 <fileclose+0xa8>

0000000080003d50 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d50:	715d                	addi	sp,sp,-80
    80003d52:	e486                	sd	ra,72(sp)
    80003d54:	e0a2                	sd	s0,64(sp)
    80003d56:	fc26                	sd	s1,56(sp)
    80003d58:	f84a                	sd	s2,48(sp)
    80003d5a:	f44e                	sd	s3,40(sp)
    80003d5c:	0880                	addi	s0,sp,80
    80003d5e:	84aa                	mv	s1,a0
    80003d60:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d62:	ffffd097          	auipc	ra,0xffffd
    80003d66:	11a080e7          	jalr	282(ra) # 80000e7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d6a:	409c                	lw	a5,0(s1)
    80003d6c:	37f9                	addiw	a5,a5,-2
    80003d6e:	4705                	li	a4,1
    80003d70:	04f76763          	bltu	a4,a5,80003dbe <filestat+0x6e>
    80003d74:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d76:	6c88                	ld	a0,24(s1)
    80003d78:	fffff097          	auipc	ra,0xfffff
    80003d7c:	072080e7          	jalr	114(ra) # 80002dea <ilock>
    stati(f->ip, &st);
    80003d80:	fb840593          	addi	a1,s0,-72
    80003d84:	6c88                	ld	a0,24(s1)
    80003d86:	fffff097          	auipc	ra,0xfffff
    80003d8a:	2ee080e7          	jalr	750(ra) # 80003074 <stati>
    iunlock(f->ip);
    80003d8e:	6c88                	ld	a0,24(s1)
    80003d90:	fffff097          	auipc	ra,0xfffff
    80003d94:	11c080e7          	jalr	284(ra) # 80002eac <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d98:	46e1                	li	a3,24
    80003d9a:	fb840613          	addi	a2,s0,-72
    80003d9e:	85ce                	mv	a1,s3
    80003da0:	05093503          	ld	a0,80(s2)
    80003da4:	ffffd097          	auipc	ra,0xffffd
    80003da8:	d48080e7          	jalr	-696(ra) # 80000aec <copyout>
    80003dac:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003db0:	60a6                	ld	ra,72(sp)
    80003db2:	6406                	ld	s0,64(sp)
    80003db4:	74e2                	ld	s1,56(sp)
    80003db6:	7942                	ld	s2,48(sp)
    80003db8:	79a2                	ld	s3,40(sp)
    80003dba:	6161                	addi	sp,sp,80
    80003dbc:	8082                	ret
  return -1;
    80003dbe:	557d                	li	a0,-1
    80003dc0:	bfc5                	j	80003db0 <filestat+0x60>

0000000080003dc2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003dc2:	7179                	addi	sp,sp,-48
    80003dc4:	f406                	sd	ra,40(sp)
    80003dc6:	f022                	sd	s0,32(sp)
    80003dc8:	ec26                	sd	s1,24(sp)
    80003dca:	e84a                	sd	s2,16(sp)
    80003dcc:	e44e                	sd	s3,8(sp)
    80003dce:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003dd0:	00854783          	lbu	a5,8(a0)
    80003dd4:	c3d5                	beqz	a5,80003e78 <fileread+0xb6>
    80003dd6:	84aa                	mv	s1,a0
    80003dd8:	89ae                	mv	s3,a1
    80003dda:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ddc:	411c                	lw	a5,0(a0)
    80003dde:	4705                	li	a4,1
    80003de0:	04e78963          	beq	a5,a4,80003e32 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003de4:	470d                	li	a4,3
    80003de6:	04e78d63          	beq	a5,a4,80003e40 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dea:	4709                	li	a4,2
    80003dec:	06e79e63          	bne	a5,a4,80003e68 <fileread+0xa6>
    ilock(f->ip);
    80003df0:	6d08                	ld	a0,24(a0)
    80003df2:	fffff097          	auipc	ra,0xfffff
    80003df6:	ff8080e7          	jalr	-8(ra) # 80002dea <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003dfa:	874a                	mv	a4,s2
    80003dfc:	5094                	lw	a3,32(s1)
    80003dfe:	864e                	mv	a2,s3
    80003e00:	4585                	li	a1,1
    80003e02:	6c88                	ld	a0,24(s1)
    80003e04:	fffff097          	auipc	ra,0xfffff
    80003e08:	29a080e7          	jalr	666(ra) # 8000309e <readi>
    80003e0c:	892a                	mv	s2,a0
    80003e0e:	00a05563          	blez	a0,80003e18 <fileread+0x56>
      f->off += r;
    80003e12:	509c                	lw	a5,32(s1)
    80003e14:	9fa9                	addw	a5,a5,a0
    80003e16:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e18:	6c88                	ld	a0,24(s1)
    80003e1a:	fffff097          	auipc	ra,0xfffff
    80003e1e:	092080e7          	jalr	146(ra) # 80002eac <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e22:	854a                	mv	a0,s2
    80003e24:	70a2                	ld	ra,40(sp)
    80003e26:	7402                	ld	s0,32(sp)
    80003e28:	64e2                	ld	s1,24(sp)
    80003e2a:	6942                	ld	s2,16(sp)
    80003e2c:	69a2                	ld	s3,8(sp)
    80003e2e:	6145                	addi	sp,sp,48
    80003e30:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e32:	6908                	ld	a0,16(a0)
    80003e34:	00000097          	auipc	ra,0x0
    80003e38:	3c8080e7          	jalr	968(ra) # 800041fc <piperead>
    80003e3c:	892a                	mv	s2,a0
    80003e3e:	b7d5                	j	80003e22 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e40:	02451783          	lh	a5,36(a0)
    80003e44:	03079693          	slli	a3,a5,0x30
    80003e48:	92c1                	srli	a3,a3,0x30
    80003e4a:	4725                	li	a4,9
    80003e4c:	02d76863          	bltu	a4,a3,80003e7c <fileread+0xba>
    80003e50:	0792                	slli	a5,a5,0x4
    80003e52:	0001d717          	auipc	a4,0x1d
    80003e56:	27670713          	addi	a4,a4,630 # 800210c8 <devsw>
    80003e5a:	97ba                	add	a5,a5,a4
    80003e5c:	639c                	ld	a5,0(a5)
    80003e5e:	c38d                	beqz	a5,80003e80 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e60:	4505                	li	a0,1
    80003e62:	9782                	jalr	a5
    80003e64:	892a                	mv	s2,a0
    80003e66:	bf75                	j	80003e22 <fileread+0x60>
    panic("fileread");
    80003e68:	00004517          	auipc	a0,0x4
    80003e6c:	7b050513          	addi	a0,a0,1968 # 80008618 <syscalls+0x268>
    80003e70:	00002097          	auipc	ra,0x2
    80003e74:	468080e7          	jalr	1128(ra) # 800062d8 <panic>
    return -1;
    80003e78:	597d                	li	s2,-1
    80003e7a:	b765                	j	80003e22 <fileread+0x60>
      return -1;
    80003e7c:	597d                	li	s2,-1
    80003e7e:	b755                	j	80003e22 <fileread+0x60>
    80003e80:	597d                	li	s2,-1
    80003e82:	b745                	j	80003e22 <fileread+0x60>

0000000080003e84 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e84:	715d                	addi	sp,sp,-80
    80003e86:	e486                	sd	ra,72(sp)
    80003e88:	e0a2                	sd	s0,64(sp)
    80003e8a:	fc26                	sd	s1,56(sp)
    80003e8c:	f84a                	sd	s2,48(sp)
    80003e8e:	f44e                	sd	s3,40(sp)
    80003e90:	f052                	sd	s4,32(sp)
    80003e92:	ec56                	sd	s5,24(sp)
    80003e94:	e85a                	sd	s6,16(sp)
    80003e96:	e45e                	sd	s7,8(sp)
    80003e98:	e062                	sd	s8,0(sp)
    80003e9a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e9c:	00954783          	lbu	a5,9(a0)
    80003ea0:	10078663          	beqz	a5,80003fac <filewrite+0x128>
    80003ea4:	892a                	mv	s2,a0
    80003ea6:	8aae                	mv	s5,a1
    80003ea8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003eaa:	411c                	lw	a5,0(a0)
    80003eac:	4705                	li	a4,1
    80003eae:	02e78263          	beq	a5,a4,80003ed2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003eb2:	470d                	li	a4,3
    80003eb4:	02e78663          	beq	a5,a4,80003ee0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003eb8:	4709                	li	a4,2
    80003eba:	0ee79163          	bne	a5,a4,80003f9c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ebe:	0ac05d63          	blez	a2,80003f78 <filewrite+0xf4>
    int i = 0;
    80003ec2:	4981                	li	s3,0
    80003ec4:	6b05                	lui	s6,0x1
    80003ec6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003eca:	6b85                	lui	s7,0x1
    80003ecc:	c00b8b9b          	addiw	s7,s7,-1024
    80003ed0:	a861                	j	80003f68 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ed2:	6908                	ld	a0,16(a0)
    80003ed4:	00000097          	auipc	ra,0x0
    80003ed8:	22e080e7          	jalr	558(ra) # 80004102 <pipewrite>
    80003edc:	8a2a                	mv	s4,a0
    80003ede:	a045                	j	80003f7e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ee0:	02451783          	lh	a5,36(a0)
    80003ee4:	03079693          	slli	a3,a5,0x30
    80003ee8:	92c1                	srli	a3,a3,0x30
    80003eea:	4725                	li	a4,9
    80003eec:	0cd76263          	bltu	a4,a3,80003fb0 <filewrite+0x12c>
    80003ef0:	0792                	slli	a5,a5,0x4
    80003ef2:	0001d717          	auipc	a4,0x1d
    80003ef6:	1d670713          	addi	a4,a4,470 # 800210c8 <devsw>
    80003efa:	97ba                	add	a5,a5,a4
    80003efc:	679c                	ld	a5,8(a5)
    80003efe:	cbdd                	beqz	a5,80003fb4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003f00:	4505                	li	a0,1
    80003f02:	9782                	jalr	a5
    80003f04:	8a2a                	mv	s4,a0
    80003f06:	a8a5                	j	80003f7e <filewrite+0xfa>
    80003f08:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003f0c:	00000097          	auipc	ra,0x0
    80003f10:	8b0080e7          	jalr	-1872(ra) # 800037bc <begin_op>
      ilock(f->ip);
    80003f14:	01893503          	ld	a0,24(s2)
    80003f18:	fffff097          	auipc	ra,0xfffff
    80003f1c:	ed2080e7          	jalr	-302(ra) # 80002dea <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f20:	8762                	mv	a4,s8
    80003f22:	02092683          	lw	a3,32(s2)
    80003f26:	01598633          	add	a2,s3,s5
    80003f2a:	4585                	li	a1,1
    80003f2c:	01893503          	ld	a0,24(s2)
    80003f30:	fffff097          	auipc	ra,0xfffff
    80003f34:	266080e7          	jalr	614(ra) # 80003196 <writei>
    80003f38:	84aa                	mv	s1,a0
    80003f3a:	00a05763          	blez	a0,80003f48 <filewrite+0xc4>
        f->off += r;
    80003f3e:	02092783          	lw	a5,32(s2)
    80003f42:	9fa9                	addw	a5,a5,a0
    80003f44:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f48:	01893503          	ld	a0,24(s2)
    80003f4c:	fffff097          	auipc	ra,0xfffff
    80003f50:	f60080e7          	jalr	-160(ra) # 80002eac <iunlock>
      end_op();
    80003f54:	00000097          	auipc	ra,0x0
    80003f58:	8e8080e7          	jalr	-1816(ra) # 8000383c <end_op>

      if(r != n1){
    80003f5c:	009c1f63          	bne	s8,s1,80003f7a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f60:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f64:	0149db63          	bge	s3,s4,80003f7a <filewrite+0xf6>
      int n1 = n - i;
    80003f68:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003f6c:	84be                	mv	s1,a5
    80003f6e:	2781                	sext.w	a5,a5
    80003f70:	f8fb5ce3          	bge	s6,a5,80003f08 <filewrite+0x84>
    80003f74:	84de                	mv	s1,s7
    80003f76:	bf49                	j	80003f08 <filewrite+0x84>
    int i = 0;
    80003f78:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f7a:	013a1f63          	bne	s4,s3,80003f98 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f7e:	8552                	mv	a0,s4
    80003f80:	60a6                	ld	ra,72(sp)
    80003f82:	6406                	ld	s0,64(sp)
    80003f84:	74e2                	ld	s1,56(sp)
    80003f86:	7942                	ld	s2,48(sp)
    80003f88:	79a2                	ld	s3,40(sp)
    80003f8a:	7a02                	ld	s4,32(sp)
    80003f8c:	6ae2                	ld	s5,24(sp)
    80003f8e:	6b42                	ld	s6,16(sp)
    80003f90:	6ba2                	ld	s7,8(sp)
    80003f92:	6c02                	ld	s8,0(sp)
    80003f94:	6161                	addi	sp,sp,80
    80003f96:	8082                	ret
    ret = (i == n ? n : -1);
    80003f98:	5a7d                	li	s4,-1
    80003f9a:	b7d5                	j	80003f7e <filewrite+0xfa>
    panic("filewrite");
    80003f9c:	00004517          	auipc	a0,0x4
    80003fa0:	68c50513          	addi	a0,a0,1676 # 80008628 <syscalls+0x278>
    80003fa4:	00002097          	auipc	ra,0x2
    80003fa8:	334080e7          	jalr	820(ra) # 800062d8 <panic>
    return -1;
    80003fac:	5a7d                	li	s4,-1
    80003fae:	bfc1                	j	80003f7e <filewrite+0xfa>
      return -1;
    80003fb0:	5a7d                	li	s4,-1
    80003fb2:	b7f1                	j	80003f7e <filewrite+0xfa>
    80003fb4:	5a7d                	li	s4,-1
    80003fb6:	b7e1                	j	80003f7e <filewrite+0xfa>

0000000080003fb8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fb8:	7179                	addi	sp,sp,-48
    80003fba:	f406                	sd	ra,40(sp)
    80003fbc:	f022                	sd	s0,32(sp)
    80003fbe:	ec26                	sd	s1,24(sp)
    80003fc0:	e84a                	sd	s2,16(sp)
    80003fc2:	e44e                	sd	s3,8(sp)
    80003fc4:	e052                	sd	s4,0(sp)
    80003fc6:	1800                	addi	s0,sp,48
    80003fc8:	84aa                	mv	s1,a0
    80003fca:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fcc:	0005b023          	sd	zero,0(a1)
    80003fd0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fd4:	00000097          	auipc	ra,0x0
    80003fd8:	bf8080e7          	jalr	-1032(ra) # 80003bcc <filealloc>
    80003fdc:	e088                	sd	a0,0(s1)
    80003fde:	c551                	beqz	a0,8000406a <pipealloc+0xb2>
    80003fe0:	00000097          	auipc	ra,0x0
    80003fe4:	bec080e7          	jalr	-1044(ra) # 80003bcc <filealloc>
    80003fe8:	00aa3023          	sd	a0,0(s4)
    80003fec:	c92d                	beqz	a0,8000405e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fee:	ffffc097          	auipc	ra,0xffffc
    80003ff2:	12a080e7          	jalr	298(ra) # 80000118 <kalloc>
    80003ff6:	892a                	mv	s2,a0
    80003ff8:	c125                	beqz	a0,80004058 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ffa:	4985                	li	s3,1
    80003ffc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004000:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004004:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004008:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000400c:	00004597          	auipc	a1,0x4
    80004010:	62c58593          	addi	a1,a1,1580 # 80008638 <syscalls+0x288>
    80004014:	00002097          	auipc	ra,0x2
    80004018:	77e080e7          	jalr	1918(ra) # 80006792 <initlock>
  (*f0)->type = FD_PIPE;
    8000401c:	609c                	ld	a5,0(s1)
    8000401e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004022:	609c                	ld	a5,0(s1)
    80004024:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004028:	609c                	ld	a5,0(s1)
    8000402a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000402e:	609c                	ld	a5,0(s1)
    80004030:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004034:	000a3783          	ld	a5,0(s4)
    80004038:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000403c:	000a3783          	ld	a5,0(s4)
    80004040:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004044:	000a3783          	ld	a5,0(s4)
    80004048:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000404c:	000a3783          	ld	a5,0(s4)
    80004050:	0127b823          	sd	s2,16(a5)
  return 0;
    80004054:	4501                	li	a0,0
    80004056:	a025                	j	8000407e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004058:	6088                	ld	a0,0(s1)
    8000405a:	e501                	bnez	a0,80004062 <pipealloc+0xaa>
    8000405c:	a039                	j	8000406a <pipealloc+0xb2>
    8000405e:	6088                	ld	a0,0(s1)
    80004060:	c51d                	beqz	a0,8000408e <pipealloc+0xd6>
    fileclose(*f0);
    80004062:	00000097          	auipc	ra,0x0
    80004066:	c26080e7          	jalr	-986(ra) # 80003c88 <fileclose>
  if(*f1)
    8000406a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000406e:	557d                	li	a0,-1
  if(*f1)
    80004070:	c799                	beqz	a5,8000407e <pipealloc+0xc6>
    fileclose(*f1);
    80004072:	853e                	mv	a0,a5
    80004074:	00000097          	auipc	ra,0x0
    80004078:	c14080e7          	jalr	-1004(ra) # 80003c88 <fileclose>
  return -1;
    8000407c:	557d                	li	a0,-1
}
    8000407e:	70a2                	ld	ra,40(sp)
    80004080:	7402                	ld	s0,32(sp)
    80004082:	64e2                	ld	s1,24(sp)
    80004084:	6942                	ld	s2,16(sp)
    80004086:	69a2                	ld	s3,8(sp)
    80004088:	6a02                	ld	s4,0(sp)
    8000408a:	6145                	addi	sp,sp,48
    8000408c:	8082                	ret
  return -1;
    8000408e:	557d                	li	a0,-1
    80004090:	b7fd                	j	8000407e <pipealloc+0xc6>

0000000080004092 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004092:	1101                	addi	sp,sp,-32
    80004094:	ec06                	sd	ra,24(sp)
    80004096:	e822                	sd	s0,16(sp)
    80004098:	e426                	sd	s1,8(sp)
    8000409a:	e04a                	sd	s2,0(sp)
    8000409c:	1000                	addi	s0,sp,32
    8000409e:	84aa                	mv	s1,a0
    800040a0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800040a2:	00002097          	auipc	ra,0x2
    800040a6:	780080e7          	jalr	1920(ra) # 80006822 <acquire>
  if(writable){
    800040aa:	02090d63          	beqz	s2,800040e4 <pipeclose+0x52>
    pi->writeopen = 0;
    800040ae:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040b2:	21848513          	addi	a0,s1,536
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	652080e7          	jalr	1618(ra) # 80001708 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040be:	2204b783          	ld	a5,544(s1)
    800040c2:	eb95                	bnez	a5,800040f6 <pipeclose+0x64>
    release(&pi->lock);
    800040c4:	8526                	mv	a0,s1
    800040c6:	00003097          	auipc	ra,0x3
    800040ca:	810080e7          	jalr	-2032(ra) # 800068d6 <release>
    kfree((char*)pi);
    800040ce:	8526                	mv	a0,s1
    800040d0:	ffffc097          	auipc	ra,0xffffc
    800040d4:	f4c080e7          	jalr	-180(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800040d8:	60e2                	ld	ra,24(sp)
    800040da:	6442                	ld	s0,16(sp)
    800040dc:	64a2                	ld	s1,8(sp)
    800040de:	6902                	ld	s2,0(sp)
    800040e0:	6105                	addi	sp,sp,32
    800040e2:	8082                	ret
    pi->readopen = 0;
    800040e4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040e8:	21c48513          	addi	a0,s1,540
    800040ec:	ffffd097          	auipc	ra,0xffffd
    800040f0:	61c080e7          	jalr	1564(ra) # 80001708 <wakeup>
    800040f4:	b7e9                	j	800040be <pipeclose+0x2c>
    release(&pi->lock);
    800040f6:	8526                	mv	a0,s1
    800040f8:	00002097          	auipc	ra,0x2
    800040fc:	7de080e7          	jalr	2014(ra) # 800068d6 <release>
}
    80004100:	bfe1                	j	800040d8 <pipeclose+0x46>

0000000080004102 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004102:	7159                	addi	sp,sp,-112
    80004104:	f486                	sd	ra,104(sp)
    80004106:	f0a2                	sd	s0,96(sp)
    80004108:	eca6                	sd	s1,88(sp)
    8000410a:	e8ca                	sd	s2,80(sp)
    8000410c:	e4ce                	sd	s3,72(sp)
    8000410e:	e0d2                	sd	s4,64(sp)
    80004110:	fc56                	sd	s5,56(sp)
    80004112:	f85a                	sd	s6,48(sp)
    80004114:	f45e                	sd	s7,40(sp)
    80004116:	f062                	sd	s8,32(sp)
    80004118:	ec66                	sd	s9,24(sp)
    8000411a:	1880                	addi	s0,sp,112
    8000411c:	84aa                	mv	s1,a0
    8000411e:	8aae                	mv	s5,a1
    80004120:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	d5a080e7          	jalr	-678(ra) # 80000e7c <myproc>
    8000412a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000412c:	8526                	mv	a0,s1
    8000412e:	00002097          	auipc	ra,0x2
    80004132:	6f4080e7          	jalr	1780(ra) # 80006822 <acquire>
  while(i < n){
    80004136:	0d405163          	blez	s4,800041f8 <pipewrite+0xf6>
    8000413a:	8ba6                	mv	s7,s1
  int i = 0;
    8000413c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000413e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004140:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004144:	21c48c13          	addi	s8,s1,540
    80004148:	a08d                	j	800041aa <pipewrite+0xa8>
      release(&pi->lock);
    8000414a:	8526                	mv	a0,s1
    8000414c:	00002097          	auipc	ra,0x2
    80004150:	78a080e7          	jalr	1930(ra) # 800068d6 <release>
      return -1;
    80004154:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004156:	854a                	mv	a0,s2
    80004158:	70a6                	ld	ra,104(sp)
    8000415a:	7406                	ld	s0,96(sp)
    8000415c:	64e6                	ld	s1,88(sp)
    8000415e:	6946                	ld	s2,80(sp)
    80004160:	69a6                	ld	s3,72(sp)
    80004162:	6a06                	ld	s4,64(sp)
    80004164:	7ae2                	ld	s5,56(sp)
    80004166:	7b42                	ld	s6,48(sp)
    80004168:	7ba2                	ld	s7,40(sp)
    8000416a:	7c02                	ld	s8,32(sp)
    8000416c:	6ce2                	ld	s9,24(sp)
    8000416e:	6165                	addi	sp,sp,112
    80004170:	8082                	ret
      wakeup(&pi->nread);
    80004172:	8566                	mv	a0,s9
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	594080e7          	jalr	1428(ra) # 80001708 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000417c:	85de                	mv	a1,s7
    8000417e:	8562                	mv	a0,s8
    80004180:	ffffd097          	auipc	ra,0xffffd
    80004184:	3fc080e7          	jalr	1020(ra) # 8000157c <sleep>
    80004188:	a839                	j	800041a6 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000418a:	21c4a783          	lw	a5,540(s1)
    8000418e:	0017871b          	addiw	a4,a5,1
    80004192:	20e4ae23          	sw	a4,540(s1)
    80004196:	1ff7f793          	andi	a5,a5,511
    8000419a:	97a6                	add	a5,a5,s1
    8000419c:	f9f44703          	lbu	a4,-97(s0)
    800041a0:	00e78c23          	sb	a4,24(a5)
      i++;
    800041a4:	2905                	addiw	s2,s2,1
  while(i < n){
    800041a6:	03495d63          	bge	s2,s4,800041e0 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800041aa:	2204a783          	lw	a5,544(s1)
    800041ae:	dfd1                	beqz	a5,8000414a <pipewrite+0x48>
    800041b0:	0289a783          	lw	a5,40(s3)
    800041b4:	fbd9                	bnez	a5,8000414a <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800041b6:	2184a783          	lw	a5,536(s1)
    800041ba:	21c4a703          	lw	a4,540(s1)
    800041be:	2007879b          	addiw	a5,a5,512
    800041c2:	faf708e3          	beq	a4,a5,80004172 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041c6:	4685                	li	a3,1
    800041c8:	01590633          	add	a2,s2,s5
    800041cc:	f9f40593          	addi	a1,s0,-97
    800041d0:	0509b503          	ld	a0,80(s3)
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	9a4080e7          	jalr	-1628(ra) # 80000b78 <copyin>
    800041dc:	fb6517e3          	bne	a0,s6,8000418a <pipewrite+0x88>
  wakeup(&pi->nread);
    800041e0:	21848513          	addi	a0,s1,536
    800041e4:	ffffd097          	auipc	ra,0xffffd
    800041e8:	524080e7          	jalr	1316(ra) # 80001708 <wakeup>
  release(&pi->lock);
    800041ec:	8526                	mv	a0,s1
    800041ee:	00002097          	auipc	ra,0x2
    800041f2:	6e8080e7          	jalr	1768(ra) # 800068d6 <release>
  return i;
    800041f6:	b785                	j	80004156 <pipewrite+0x54>
  int i = 0;
    800041f8:	4901                	li	s2,0
    800041fa:	b7dd                	j	800041e0 <pipewrite+0xde>

00000000800041fc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041fc:	715d                	addi	sp,sp,-80
    800041fe:	e486                	sd	ra,72(sp)
    80004200:	e0a2                	sd	s0,64(sp)
    80004202:	fc26                	sd	s1,56(sp)
    80004204:	f84a                	sd	s2,48(sp)
    80004206:	f44e                	sd	s3,40(sp)
    80004208:	f052                	sd	s4,32(sp)
    8000420a:	ec56                	sd	s5,24(sp)
    8000420c:	e85a                	sd	s6,16(sp)
    8000420e:	0880                	addi	s0,sp,80
    80004210:	84aa                	mv	s1,a0
    80004212:	892e                	mv	s2,a1
    80004214:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004216:	ffffd097          	auipc	ra,0xffffd
    8000421a:	c66080e7          	jalr	-922(ra) # 80000e7c <myproc>
    8000421e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004220:	8b26                	mv	s6,s1
    80004222:	8526                	mv	a0,s1
    80004224:	00002097          	auipc	ra,0x2
    80004228:	5fe080e7          	jalr	1534(ra) # 80006822 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000422c:	2184a703          	lw	a4,536(s1)
    80004230:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004234:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004238:	02f71463          	bne	a4,a5,80004260 <piperead+0x64>
    8000423c:	2244a783          	lw	a5,548(s1)
    80004240:	c385                	beqz	a5,80004260 <piperead+0x64>
    if(pr->killed){
    80004242:	028a2783          	lw	a5,40(s4)
    80004246:	ebc1                	bnez	a5,800042d6 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004248:	85da                	mv	a1,s6
    8000424a:	854e                	mv	a0,s3
    8000424c:	ffffd097          	auipc	ra,0xffffd
    80004250:	330080e7          	jalr	816(ra) # 8000157c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004254:	2184a703          	lw	a4,536(s1)
    80004258:	21c4a783          	lw	a5,540(s1)
    8000425c:	fef700e3          	beq	a4,a5,8000423c <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004260:	09505263          	blez	s5,800042e4 <piperead+0xe8>
    80004264:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004266:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004268:	2184a783          	lw	a5,536(s1)
    8000426c:	21c4a703          	lw	a4,540(s1)
    80004270:	02f70d63          	beq	a4,a5,800042aa <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004274:	0017871b          	addiw	a4,a5,1
    80004278:	20e4ac23          	sw	a4,536(s1)
    8000427c:	1ff7f793          	andi	a5,a5,511
    80004280:	97a6                	add	a5,a5,s1
    80004282:	0187c783          	lbu	a5,24(a5)
    80004286:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000428a:	4685                	li	a3,1
    8000428c:	fbf40613          	addi	a2,s0,-65
    80004290:	85ca                	mv	a1,s2
    80004292:	050a3503          	ld	a0,80(s4)
    80004296:	ffffd097          	auipc	ra,0xffffd
    8000429a:	856080e7          	jalr	-1962(ra) # 80000aec <copyout>
    8000429e:	01650663          	beq	a0,s6,800042aa <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042a2:	2985                	addiw	s3,s3,1
    800042a4:	0905                	addi	s2,s2,1
    800042a6:	fd3a91e3          	bne	s5,s3,80004268 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042aa:	21c48513          	addi	a0,s1,540
    800042ae:	ffffd097          	auipc	ra,0xffffd
    800042b2:	45a080e7          	jalr	1114(ra) # 80001708 <wakeup>
  release(&pi->lock);
    800042b6:	8526                	mv	a0,s1
    800042b8:	00002097          	auipc	ra,0x2
    800042bc:	61e080e7          	jalr	1566(ra) # 800068d6 <release>
  return i;
}
    800042c0:	854e                	mv	a0,s3
    800042c2:	60a6                	ld	ra,72(sp)
    800042c4:	6406                	ld	s0,64(sp)
    800042c6:	74e2                	ld	s1,56(sp)
    800042c8:	7942                	ld	s2,48(sp)
    800042ca:	79a2                	ld	s3,40(sp)
    800042cc:	7a02                	ld	s4,32(sp)
    800042ce:	6ae2                	ld	s5,24(sp)
    800042d0:	6b42                	ld	s6,16(sp)
    800042d2:	6161                	addi	sp,sp,80
    800042d4:	8082                	ret
      release(&pi->lock);
    800042d6:	8526                	mv	a0,s1
    800042d8:	00002097          	auipc	ra,0x2
    800042dc:	5fe080e7          	jalr	1534(ra) # 800068d6 <release>
      return -1;
    800042e0:	59fd                	li	s3,-1
    800042e2:	bff9                	j	800042c0 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042e4:	4981                	li	s3,0
    800042e6:	b7d1                	j	800042aa <piperead+0xae>

00000000800042e8 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042e8:	df010113          	addi	sp,sp,-528
    800042ec:	20113423          	sd	ra,520(sp)
    800042f0:	20813023          	sd	s0,512(sp)
    800042f4:	ffa6                	sd	s1,504(sp)
    800042f6:	fbca                	sd	s2,496(sp)
    800042f8:	f7ce                	sd	s3,488(sp)
    800042fa:	f3d2                	sd	s4,480(sp)
    800042fc:	efd6                	sd	s5,472(sp)
    800042fe:	ebda                	sd	s6,464(sp)
    80004300:	e7de                	sd	s7,456(sp)
    80004302:	e3e2                	sd	s8,448(sp)
    80004304:	ff66                	sd	s9,440(sp)
    80004306:	fb6a                	sd	s10,432(sp)
    80004308:	f76e                	sd	s11,424(sp)
    8000430a:	0c00                	addi	s0,sp,528
    8000430c:	84aa                	mv	s1,a0
    8000430e:	dea43c23          	sd	a0,-520(s0)
    80004312:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004316:	ffffd097          	auipc	ra,0xffffd
    8000431a:	b66080e7          	jalr	-1178(ra) # 80000e7c <myproc>
    8000431e:	892a                	mv	s2,a0

  begin_op();
    80004320:	fffff097          	auipc	ra,0xfffff
    80004324:	49c080e7          	jalr	1180(ra) # 800037bc <begin_op>

  if((ip = namei(path)) == 0){
    80004328:	8526                	mv	a0,s1
    8000432a:	fffff097          	auipc	ra,0xfffff
    8000432e:	276080e7          	jalr	630(ra) # 800035a0 <namei>
    80004332:	c92d                	beqz	a0,800043a4 <exec+0xbc>
    80004334:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004336:	fffff097          	auipc	ra,0xfffff
    8000433a:	ab4080e7          	jalr	-1356(ra) # 80002dea <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000433e:	04000713          	li	a4,64
    80004342:	4681                	li	a3,0
    80004344:	e5040613          	addi	a2,s0,-432
    80004348:	4581                	li	a1,0
    8000434a:	8526                	mv	a0,s1
    8000434c:	fffff097          	auipc	ra,0xfffff
    80004350:	d52080e7          	jalr	-686(ra) # 8000309e <readi>
    80004354:	04000793          	li	a5,64
    80004358:	00f51a63          	bne	a0,a5,8000436c <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000435c:	e5042703          	lw	a4,-432(s0)
    80004360:	464c47b7          	lui	a5,0x464c4
    80004364:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004368:	04f70463          	beq	a4,a5,800043b0 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000436c:	8526                	mv	a0,s1
    8000436e:	fffff097          	auipc	ra,0xfffff
    80004372:	cde080e7          	jalr	-802(ra) # 8000304c <iunlockput>
    end_op();
    80004376:	fffff097          	auipc	ra,0xfffff
    8000437a:	4c6080e7          	jalr	1222(ra) # 8000383c <end_op>
  }
  return -1;
    8000437e:	557d                	li	a0,-1
}
    80004380:	20813083          	ld	ra,520(sp)
    80004384:	20013403          	ld	s0,512(sp)
    80004388:	74fe                	ld	s1,504(sp)
    8000438a:	795e                	ld	s2,496(sp)
    8000438c:	79be                	ld	s3,488(sp)
    8000438e:	7a1e                	ld	s4,480(sp)
    80004390:	6afe                	ld	s5,472(sp)
    80004392:	6b5e                	ld	s6,464(sp)
    80004394:	6bbe                	ld	s7,456(sp)
    80004396:	6c1e                	ld	s8,448(sp)
    80004398:	7cfa                	ld	s9,440(sp)
    8000439a:	7d5a                	ld	s10,432(sp)
    8000439c:	7dba                	ld	s11,424(sp)
    8000439e:	21010113          	addi	sp,sp,528
    800043a2:	8082                	ret
    end_op();
    800043a4:	fffff097          	auipc	ra,0xfffff
    800043a8:	498080e7          	jalr	1176(ra) # 8000383c <end_op>
    return -1;
    800043ac:	557d                	li	a0,-1
    800043ae:	bfc9                	j	80004380 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800043b0:	854a                	mv	a0,s2
    800043b2:	ffffd097          	auipc	ra,0xffffd
    800043b6:	b8e080e7          	jalr	-1138(ra) # 80000f40 <proc_pagetable>
    800043ba:	8baa                	mv	s7,a0
    800043bc:	d945                	beqz	a0,8000436c <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043be:	e7042983          	lw	s3,-400(s0)
    800043c2:	e8845783          	lhu	a5,-376(s0)
    800043c6:	c7ad                	beqz	a5,80004430 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043c8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ca:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800043cc:	6c85                	lui	s9,0x1
    800043ce:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043d2:	def43823          	sd	a5,-528(s0)
    800043d6:	a42d                	j	80004600 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800043d8:	00004517          	auipc	a0,0x4
    800043dc:	26850513          	addi	a0,a0,616 # 80008640 <syscalls+0x290>
    800043e0:	00002097          	auipc	ra,0x2
    800043e4:	ef8080e7          	jalr	-264(ra) # 800062d8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043e8:	8756                	mv	a4,s5
    800043ea:	012d86bb          	addw	a3,s11,s2
    800043ee:	4581                	li	a1,0
    800043f0:	8526                	mv	a0,s1
    800043f2:	fffff097          	auipc	ra,0xfffff
    800043f6:	cac080e7          	jalr	-852(ra) # 8000309e <readi>
    800043fa:	2501                	sext.w	a0,a0
    800043fc:	1aaa9963          	bne	s5,a0,800045ae <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004400:	6785                	lui	a5,0x1
    80004402:	0127893b          	addw	s2,a5,s2
    80004406:	77fd                	lui	a5,0xfffff
    80004408:	01478a3b          	addw	s4,a5,s4
    8000440c:	1f897163          	bgeu	s2,s8,800045ee <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004410:	02091593          	slli	a1,s2,0x20
    80004414:	9181                	srli	a1,a1,0x20
    80004416:	95ea                	add	a1,a1,s10
    80004418:	855e                	mv	a0,s7
    8000441a:	ffffc097          	auipc	ra,0xffffc
    8000441e:	0ec080e7          	jalr	236(ra) # 80000506 <walkaddr>
    80004422:	862a                	mv	a2,a0
    if(pa == 0)
    80004424:	d955                	beqz	a0,800043d8 <exec+0xf0>
      n = PGSIZE;
    80004426:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004428:	fd9a70e3          	bgeu	s4,s9,800043e8 <exec+0x100>
      n = sz - i;
    8000442c:	8ad2                	mv	s5,s4
    8000442e:	bf6d                	j	800043e8 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004430:	4901                	li	s2,0
  iunlockput(ip);
    80004432:	8526                	mv	a0,s1
    80004434:	fffff097          	auipc	ra,0xfffff
    80004438:	c18080e7          	jalr	-1000(ra) # 8000304c <iunlockput>
  end_op();
    8000443c:	fffff097          	auipc	ra,0xfffff
    80004440:	400080e7          	jalr	1024(ra) # 8000383c <end_op>
  p = myproc();
    80004444:	ffffd097          	auipc	ra,0xffffd
    80004448:	a38080e7          	jalr	-1480(ra) # 80000e7c <myproc>
    8000444c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000444e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004452:	6785                	lui	a5,0x1
    80004454:	17fd                	addi	a5,a5,-1
    80004456:	993e                	add	s2,s2,a5
    80004458:	757d                	lui	a0,0xfffff
    8000445a:	00a977b3          	and	a5,s2,a0
    8000445e:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004462:	6609                	lui	a2,0x2
    80004464:	963e                	add	a2,a2,a5
    80004466:	85be                	mv	a1,a5
    80004468:	855e                	mv	a0,s7
    8000446a:	ffffc097          	auipc	ra,0xffffc
    8000446e:	432080e7          	jalr	1074(ra) # 8000089c <uvmalloc>
    80004472:	8b2a                	mv	s6,a0
  ip = 0;
    80004474:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004476:	12050c63          	beqz	a0,800045ae <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000447a:	75f9                	lui	a1,0xffffe
    8000447c:	95aa                	add	a1,a1,a0
    8000447e:	855e                	mv	a0,s7
    80004480:	ffffc097          	auipc	ra,0xffffc
    80004484:	63a080e7          	jalr	1594(ra) # 80000aba <uvmclear>
  stackbase = sp - PGSIZE;
    80004488:	7c7d                	lui	s8,0xfffff
    8000448a:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000448c:	e0043783          	ld	a5,-512(s0)
    80004490:	6388                	ld	a0,0(a5)
    80004492:	c535                	beqz	a0,800044fe <exec+0x216>
    80004494:	e9040993          	addi	s3,s0,-368
    80004498:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000449c:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000449e:	ffffc097          	auipc	ra,0xffffc
    800044a2:	e5e080e7          	jalr	-418(ra) # 800002fc <strlen>
    800044a6:	2505                	addiw	a0,a0,1
    800044a8:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044ac:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800044b0:	13896363          	bltu	s2,s8,800045d6 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044b4:	e0043d83          	ld	s11,-512(s0)
    800044b8:	000dba03          	ld	s4,0(s11)
    800044bc:	8552                	mv	a0,s4
    800044be:	ffffc097          	auipc	ra,0xffffc
    800044c2:	e3e080e7          	jalr	-450(ra) # 800002fc <strlen>
    800044c6:	0015069b          	addiw	a3,a0,1
    800044ca:	8652                	mv	a2,s4
    800044cc:	85ca                	mv	a1,s2
    800044ce:	855e                	mv	a0,s7
    800044d0:	ffffc097          	auipc	ra,0xffffc
    800044d4:	61c080e7          	jalr	1564(ra) # 80000aec <copyout>
    800044d8:	10054363          	bltz	a0,800045de <exec+0x2f6>
    ustack[argc] = sp;
    800044dc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044e0:	0485                	addi	s1,s1,1
    800044e2:	008d8793          	addi	a5,s11,8
    800044e6:	e0f43023          	sd	a5,-512(s0)
    800044ea:	008db503          	ld	a0,8(s11)
    800044ee:	c911                	beqz	a0,80004502 <exec+0x21a>
    if(argc >= MAXARG)
    800044f0:	09a1                	addi	s3,s3,8
    800044f2:	fb3c96e3          	bne	s9,s3,8000449e <exec+0x1b6>
  sz = sz1;
    800044f6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044fa:	4481                	li	s1,0
    800044fc:	a84d                	j	800045ae <exec+0x2c6>
  sp = sz;
    800044fe:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004500:	4481                	li	s1,0
  ustack[argc] = 0;
    80004502:	00349793          	slli	a5,s1,0x3
    80004506:	f9040713          	addi	a4,s0,-112
    8000450a:	97ba                	add	a5,a5,a4
    8000450c:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004510:	00148693          	addi	a3,s1,1
    80004514:	068e                	slli	a3,a3,0x3
    80004516:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000451a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000451e:	01897663          	bgeu	s2,s8,8000452a <exec+0x242>
  sz = sz1;
    80004522:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004526:	4481                	li	s1,0
    80004528:	a059                	j	800045ae <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000452a:	e9040613          	addi	a2,s0,-368
    8000452e:	85ca                	mv	a1,s2
    80004530:	855e                	mv	a0,s7
    80004532:	ffffc097          	auipc	ra,0xffffc
    80004536:	5ba080e7          	jalr	1466(ra) # 80000aec <copyout>
    8000453a:	0a054663          	bltz	a0,800045e6 <exec+0x2fe>
  p->trapframe->a1 = sp;
    8000453e:	058ab783          	ld	a5,88(s5)
    80004542:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004546:	df843783          	ld	a5,-520(s0)
    8000454a:	0007c703          	lbu	a4,0(a5)
    8000454e:	cf11                	beqz	a4,8000456a <exec+0x282>
    80004550:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004552:	02f00693          	li	a3,47
    80004556:	a039                	j	80004564 <exec+0x27c>
      last = s+1;
    80004558:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000455c:	0785                	addi	a5,a5,1
    8000455e:	fff7c703          	lbu	a4,-1(a5)
    80004562:	c701                	beqz	a4,8000456a <exec+0x282>
    if(*s == '/')
    80004564:	fed71ce3          	bne	a4,a3,8000455c <exec+0x274>
    80004568:	bfc5                	j	80004558 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000456a:	4641                	li	a2,16
    8000456c:	df843583          	ld	a1,-520(s0)
    80004570:	158a8513          	addi	a0,s5,344
    80004574:	ffffc097          	auipc	ra,0xffffc
    80004578:	d56080e7          	jalr	-682(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    8000457c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004580:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004584:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004588:	058ab783          	ld	a5,88(s5)
    8000458c:	e6843703          	ld	a4,-408(s0)
    80004590:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004592:	058ab783          	ld	a5,88(s5)
    80004596:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000459a:	85ea                	mv	a1,s10
    8000459c:	ffffd097          	auipc	ra,0xffffd
    800045a0:	a40080e7          	jalr	-1472(ra) # 80000fdc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045a4:	0004851b          	sext.w	a0,s1
    800045a8:	bbe1                	j	80004380 <exec+0x98>
    800045aa:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800045ae:	e0843583          	ld	a1,-504(s0)
    800045b2:	855e                	mv	a0,s7
    800045b4:	ffffd097          	auipc	ra,0xffffd
    800045b8:	a28080e7          	jalr	-1496(ra) # 80000fdc <proc_freepagetable>
  if(ip){
    800045bc:	da0498e3          	bnez	s1,8000436c <exec+0x84>
  return -1;
    800045c0:	557d                	li	a0,-1
    800045c2:	bb7d                	j	80004380 <exec+0x98>
    800045c4:	e1243423          	sd	s2,-504(s0)
    800045c8:	b7dd                	j	800045ae <exec+0x2c6>
    800045ca:	e1243423          	sd	s2,-504(s0)
    800045ce:	b7c5                	j	800045ae <exec+0x2c6>
    800045d0:	e1243423          	sd	s2,-504(s0)
    800045d4:	bfe9                	j	800045ae <exec+0x2c6>
  sz = sz1;
    800045d6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045da:	4481                	li	s1,0
    800045dc:	bfc9                	j	800045ae <exec+0x2c6>
  sz = sz1;
    800045de:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045e2:	4481                	li	s1,0
    800045e4:	b7e9                	j	800045ae <exec+0x2c6>
  sz = sz1;
    800045e6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045ea:	4481                	li	s1,0
    800045ec:	b7c9                	j	800045ae <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045ee:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045f2:	2b05                	addiw	s6,s6,1
    800045f4:	0389899b          	addiw	s3,s3,56
    800045f8:	e8845783          	lhu	a5,-376(s0)
    800045fc:	e2fb5be3          	bge	s6,a5,80004432 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004600:	2981                	sext.w	s3,s3
    80004602:	03800713          	li	a4,56
    80004606:	86ce                	mv	a3,s3
    80004608:	e1840613          	addi	a2,s0,-488
    8000460c:	4581                	li	a1,0
    8000460e:	8526                	mv	a0,s1
    80004610:	fffff097          	auipc	ra,0xfffff
    80004614:	a8e080e7          	jalr	-1394(ra) # 8000309e <readi>
    80004618:	03800793          	li	a5,56
    8000461c:	f8f517e3          	bne	a0,a5,800045aa <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004620:	e1842783          	lw	a5,-488(s0)
    80004624:	4705                	li	a4,1
    80004626:	fce796e3          	bne	a5,a4,800045f2 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    8000462a:	e4043603          	ld	a2,-448(s0)
    8000462e:	e3843783          	ld	a5,-456(s0)
    80004632:	f8f669e3          	bltu	a2,a5,800045c4 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004636:	e2843783          	ld	a5,-472(s0)
    8000463a:	963e                	add	a2,a2,a5
    8000463c:	f8f667e3          	bltu	a2,a5,800045ca <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004640:	85ca                	mv	a1,s2
    80004642:	855e                	mv	a0,s7
    80004644:	ffffc097          	auipc	ra,0xffffc
    80004648:	258080e7          	jalr	600(ra) # 8000089c <uvmalloc>
    8000464c:	e0a43423          	sd	a0,-504(s0)
    80004650:	d141                	beqz	a0,800045d0 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004652:	e2843d03          	ld	s10,-472(s0)
    80004656:	df043783          	ld	a5,-528(s0)
    8000465a:	00fd77b3          	and	a5,s10,a5
    8000465e:	fba1                	bnez	a5,800045ae <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004660:	e2042d83          	lw	s11,-480(s0)
    80004664:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004668:	f80c03e3          	beqz	s8,800045ee <exec+0x306>
    8000466c:	8a62                	mv	s4,s8
    8000466e:	4901                	li	s2,0
    80004670:	b345                	j	80004410 <exec+0x128>

0000000080004672 <argfd>:
#define min(a, b) ((a) < (b) ? (a) : (b))   
// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004672:	7179                	addi	sp,sp,-48
    80004674:	f406                	sd	ra,40(sp)
    80004676:	f022                	sd	s0,32(sp)
    80004678:	ec26                	sd	s1,24(sp)
    8000467a:	e84a                	sd	s2,16(sp)
    8000467c:	1800                	addi	s0,sp,48
    8000467e:	892e                	mv	s2,a1
    80004680:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004682:	fdc40593          	addi	a1,s0,-36
    80004686:	ffffe097          	auipc	ra,0xffffe
    8000468a:	bf2080e7          	jalr	-1038(ra) # 80002278 <argint>
    8000468e:	04054063          	bltz	a0,800046ce <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004692:	fdc42703          	lw	a4,-36(s0)
    80004696:	47bd                	li	a5,15
    80004698:	02e7ed63          	bltu	a5,a4,800046d2 <argfd+0x60>
    8000469c:	ffffc097          	auipc	ra,0xffffc
    800046a0:	7e0080e7          	jalr	2016(ra) # 80000e7c <myproc>
    800046a4:	fdc42703          	lw	a4,-36(s0)
    800046a8:	01a70793          	addi	a5,a4,26
    800046ac:	078e                	slli	a5,a5,0x3
    800046ae:	953e                	add	a0,a0,a5
    800046b0:	611c                	ld	a5,0(a0)
    800046b2:	c395                	beqz	a5,800046d6 <argfd+0x64>
    return -1;
  if(pfd)
    800046b4:	00090463          	beqz	s2,800046bc <argfd+0x4a>
    *pfd = fd;
    800046b8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046bc:	4501                	li	a0,0
  if(pf)
    800046be:	c091                	beqz	s1,800046c2 <argfd+0x50>
    *pf = f;
    800046c0:	e09c                	sd	a5,0(s1)
}
    800046c2:	70a2                	ld	ra,40(sp)
    800046c4:	7402                	ld	s0,32(sp)
    800046c6:	64e2                	ld	s1,24(sp)
    800046c8:	6942                	ld	s2,16(sp)
    800046ca:	6145                	addi	sp,sp,48
    800046cc:	8082                	ret
    return -1;
    800046ce:	557d                	li	a0,-1
    800046d0:	bfcd                	j	800046c2 <argfd+0x50>
    return -1;
    800046d2:	557d                	li	a0,-1
    800046d4:	b7fd                	j	800046c2 <argfd+0x50>
    800046d6:	557d                	li	a0,-1
    800046d8:	b7ed                	j	800046c2 <argfd+0x50>

00000000800046da <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046da:	1101                	addi	sp,sp,-32
    800046dc:	ec06                	sd	ra,24(sp)
    800046de:	e822                	sd	s0,16(sp)
    800046e0:	e426                	sd	s1,8(sp)
    800046e2:	1000                	addi	s0,sp,32
    800046e4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046e6:	ffffc097          	auipc	ra,0xffffc
    800046ea:	796080e7          	jalr	1942(ra) # 80000e7c <myproc>
    800046ee:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046f0:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd0e90>
    800046f4:	4501                	li	a0,0
    800046f6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046f8:	6398                	ld	a4,0(a5)
    800046fa:	cb19                	beqz	a4,80004710 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046fc:	2505                	addiw	a0,a0,1
    800046fe:	07a1                	addi	a5,a5,8
    80004700:	fed51ce3          	bne	a0,a3,800046f8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004704:	557d                	li	a0,-1
}
    80004706:	60e2                	ld	ra,24(sp)
    80004708:	6442                	ld	s0,16(sp)
    8000470a:	64a2                	ld	s1,8(sp)
    8000470c:	6105                	addi	sp,sp,32
    8000470e:	8082                	ret
      p->ofile[fd] = f;
    80004710:	01a50793          	addi	a5,a0,26
    80004714:	078e                	slli	a5,a5,0x3
    80004716:	963e                	add	a2,a2,a5
    80004718:	e204                	sd	s1,0(a2)
      return fd;
    8000471a:	b7f5                	j	80004706 <fdalloc+0x2c>

000000008000471c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000471c:	715d                	addi	sp,sp,-80
    8000471e:	e486                	sd	ra,72(sp)
    80004720:	e0a2                	sd	s0,64(sp)
    80004722:	fc26                	sd	s1,56(sp)
    80004724:	f84a                	sd	s2,48(sp)
    80004726:	f44e                	sd	s3,40(sp)
    80004728:	f052                	sd	s4,32(sp)
    8000472a:	ec56                	sd	s5,24(sp)
    8000472c:	0880                	addi	s0,sp,80
    8000472e:	89ae                	mv	s3,a1
    80004730:	8ab2                	mv	s5,a2
    80004732:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004734:	fb040593          	addi	a1,s0,-80
    80004738:	fffff097          	auipc	ra,0xfffff
    8000473c:	e86080e7          	jalr	-378(ra) # 800035be <nameiparent>
    80004740:	892a                	mv	s2,a0
    80004742:	12050f63          	beqz	a0,80004880 <create+0x164>
    return 0;

  ilock(dp);
    80004746:	ffffe097          	auipc	ra,0xffffe
    8000474a:	6a4080e7          	jalr	1700(ra) # 80002dea <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000474e:	4601                	li	a2,0
    80004750:	fb040593          	addi	a1,s0,-80
    80004754:	854a                	mv	a0,s2
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	b78080e7          	jalr	-1160(ra) # 800032ce <dirlookup>
    8000475e:	84aa                	mv	s1,a0
    80004760:	c921                	beqz	a0,800047b0 <create+0x94>
    iunlockput(dp);
    80004762:	854a                	mv	a0,s2
    80004764:	fffff097          	auipc	ra,0xfffff
    80004768:	8e8080e7          	jalr	-1816(ra) # 8000304c <iunlockput>
    ilock(ip);
    8000476c:	8526                	mv	a0,s1
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	67c080e7          	jalr	1660(ra) # 80002dea <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004776:	2981                	sext.w	s3,s3
    80004778:	4789                	li	a5,2
    8000477a:	02f99463          	bne	s3,a5,800047a2 <create+0x86>
    8000477e:	0444d783          	lhu	a5,68(s1)
    80004782:	37f9                	addiw	a5,a5,-2
    80004784:	17c2                	slli	a5,a5,0x30
    80004786:	93c1                	srli	a5,a5,0x30
    80004788:	4705                	li	a4,1
    8000478a:	00f76c63          	bltu	a4,a5,800047a2 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000478e:	8526                	mv	a0,s1
    80004790:	60a6                	ld	ra,72(sp)
    80004792:	6406                	ld	s0,64(sp)
    80004794:	74e2                	ld	s1,56(sp)
    80004796:	7942                	ld	s2,48(sp)
    80004798:	79a2                	ld	s3,40(sp)
    8000479a:	7a02                	ld	s4,32(sp)
    8000479c:	6ae2                	ld	s5,24(sp)
    8000479e:	6161                	addi	sp,sp,80
    800047a0:	8082                	ret
    iunlockput(ip);
    800047a2:	8526                	mv	a0,s1
    800047a4:	fffff097          	auipc	ra,0xfffff
    800047a8:	8a8080e7          	jalr	-1880(ra) # 8000304c <iunlockput>
    return 0;
    800047ac:	4481                	li	s1,0
    800047ae:	b7c5                	j	8000478e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800047b0:	85ce                	mv	a1,s3
    800047b2:	00092503          	lw	a0,0(s2)
    800047b6:	ffffe097          	auipc	ra,0xffffe
    800047ba:	49c080e7          	jalr	1180(ra) # 80002c52 <ialloc>
    800047be:	84aa                	mv	s1,a0
    800047c0:	c529                	beqz	a0,8000480a <create+0xee>
  ilock(ip);
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	628080e7          	jalr	1576(ra) # 80002dea <ilock>
  ip->major = major;
    800047ca:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800047ce:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800047d2:	4785                	li	a5,1
    800047d4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047d8:	8526                	mv	a0,s1
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	546080e7          	jalr	1350(ra) # 80002d20 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047e2:	2981                	sext.w	s3,s3
    800047e4:	4785                	li	a5,1
    800047e6:	02f98a63          	beq	s3,a5,8000481a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800047ea:	40d0                	lw	a2,4(s1)
    800047ec:	fb040593          	addi	a1,s0,-80
    800047f0:	854a                	mv	a0,s2
    800047f2:	fffff097          	auipc	ra,0xfffff
    800047f6:	cec080e7          	jalr	-788(ra) # 800034de <dirlink>
    800047fa:	06054b63          	bltz	a0,80004870 <create+0x154>
  iunlockput(dp);
    800047fe:	854a                	mv	a0,s2
    80004800:	fffff097          	auipc	ra,0xfffff
    80004804:	84c080e7          	jalr	-1972(ra) # 8000304c <iunlockput>
  return ip;
    80004808:	b759                	j	8000478e <create+0x72>
    panic("create: ialloc");
    8000480a:	00004517          	auipc	a0,0x4
    8000480e:	e5650513          	addi	a0,a0,-426 # 80008660 <syscalls+0x2b0>
    80004812:	00002097          	auipc	ra,0x2
    80004816:	ac6080e7          	jalr	-1338(ra) # 800062d8 <panic>
    dp->nlink++;  // for ".."
    8000481a:	04a95783          	lhu	a5,74(s2)
    8000481e:	2785                	addiw	a5,a5,1
    80004820:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004824:	854a                	mv	a0,s2
    80004826:	ffffe097          	auipc	ra,0xffffe
    8000482a:	4fa080e7          	jalr	1274(ra) # 80002d20 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000482e:	40d0                	lw	a2,4(s1)
    80004830:	00004597          	auipc	a1,0x4
    80004834:	e4058593          	addi	a1,a1,-448 # 80008670 <syscalls+0x2c0>
    80004838:	8526                	mv	a0,s1
    8000483a:	fffff097          	auipc	ra,0xfffff
    8000483e:	ca4080e7          	jalr	-860(ra) # 800034de <dirlink>
    80004842:	00054f63          	bltz	a0,80004860 <create+0x144>
    80004846:	00492603          	lw	a2,4(s2)
    8000484a:	00004597          	auipc	a1,0x4
    8000484e:	e2e58593          	addi	a1,a1,-466 # 80008678 <syscalls+0x2c8>
    80004852:	8526                	mv	a0,s1
    80004854:	fffff097          	auipc	ra,0xfffff
    80004858:	c8a080e7          	jalr	-886(ra) # 800034de <dirlink>
    8000485c:	f80557e3          	bgez	a0,800047ea <create+0xce>
      panic("create dots");
    80004860:	00004517          	auipc	a0,0x4
    80004864:	e2050513          	addi	a0,a0,-480 # 80008680 <syscalls+0x2d0>
    80004868:	00002097          	auipc	ra,0x2
    8000486c:	a70080e7          	jalr	-1424(ra) # 800062d8 <panic>
    panic("create: dirlink");
    80004870:	00004517          	auipc	a0,0x4
    80004874:	e2050513          	addi	a0,a0,-480 # 80008690 <syscalls+0x2e0>
    80004878:	00002097          	auipc	ra,0x2
    8000487c:	a60080e7          	jalr	-1440(ra) # 800062d8 <panic>
    return 0;
    80004880:	84aa                	mv	s1,a0
    80004882:	b731                	j	8000478e <create+0x72>

0000000080004884 <sys_dup>:
{
    80004884:	7179                	addi	sp,sp,-48
    80004886:	f406                	sd	ra,40(sp)
    80004888:	f022                	sd	s0,32(sp)
    8000488a:	ec26                	sd	s1,24(sp)
    8000488c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000488e:	fd840613          	addi	a2,s0,-40
    80004892:	4581                	li	a1,0
    80004894:	4501                	li	a0,0
    80004896:	00000097          	auipc	ra,0x0
    8000489a:	ddc080e7          	jalr	-548(ra) # 80004672 <argfd>
    return -1;
    8000489e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048a0:	02054363          	bltz	a0,800048c6 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800048a4:	fd843503          	ld	a0,-40(s0)
    800048a8:	00000097          	auipc	ra,0x0
    800048ac:	e32080e7          	jalr	-462(ra) # 800046da <fdalloc>
    800048b0:	84aa                	mv	s1,a0
    return -1;
    800048b2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048b4:	00054963          	bltz	a0,800048c6 <sys_dup+0x42>
  filedup(f);
    800048b8:	fd843503          	ld	a0,-40(s0)
    800048bc:	fffff097          	auipc	ra,0xfffff
    800048c0:	37a080e7          	jalr	890(ra) # 80003c36 <filedup>
  return fd;
    800048c4:	87a6                	mv	a5,s1
}
    800048c6:	853e                	mv	a0,a5
    800048c8:	70a2                	ld	ra,40(sp)
    800048ca:	7402                	ld	s0,32(sp)
    800048cc:	64e2                	ld	s1,24(sp)
    800048ce:	6145                	addi	sp,sp,48
    800048d0:	8082                	ret

00000000800048d2 <sys_read>:
{
    800048d2:	7179                	addi	sp,sp,-48
    800048d4:	f406                	sd	ra,40(sp)
    800048d6:	f022                	sd	s0,32(sp)
    800048d8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048da:	fe840613          	addi	a2,s0,-24
    800048de:	4581                	li	a1,0
    800048e0:	4501                	li	a0,0
    800048e2:	00000097          	auipc	ra,0x0
    800048e6:	d90080e7          	jalr	-624(ra) # 80004672 <argfd>
    return -1;
    800048ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ec:	04054163          	bltz	a0,8000492e <sys_read+0x5c>
    800048f0:	fe440593          	addi	a1,s0,-28
    800048f4:	4509                	li	a0,2
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	982080e7          	jalr	-1662(ra) # 80002278 <argint>
    return -1;
    800048fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004900:	02054763          	bltz	a0,8000492e <sys_read+0x5c>
    80004904:	fd840593          	addi	a1,s0,-40
    80004908:	4505                	li	a0,1
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	990080e7          	jalr	-1648(ra) # 8000229a <argaddr>
    return -1;
    80004912:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004914:	00054d63          	bltz	a0,8000492e <sys_read+0x5c>
  return fileread(f, p, n);
    80004918:	fe442603          	lw	a2,-28(s0)
    8000491c:	fd843583          	ld	a1,-40(s0)
    80004920:	fe843503          	ld	a0,-24(s0)
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	49e080e7          	jalr	1182(ra) # 80003dc2 <fileread>
    8000492c:	87aa                	mv	a5,a0
}
    8000492e:	853e                	mv	a0,a5
    80004930:	70a2                	ld	ra,40(sp)
    80004932:	7402                	ld	s0,32(sp)
    80004934:	6145                	addi	sp,sp,48
    80004936:	8082                	ret

0000000080004938 <sys_write>:
{
    80004938:	7179                	addi	sp,sp,-48
    8000493a:	f406                	sd	ra,40(sp)
    8000493c:	f022                	sd	s0,32(sp)
    8000493e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004940:	fe840613          	addi	a2,s0,-24
    80004944:	4581                	li	a1,0
    80004946:	4501                	li	a0,0
    80004948:	00000097          	auipc	ra,0x0
    8000494c:	d2a080e7          	jalr	-726(ra) # 80004672 <argfd>
    return -1;
    80004950:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004952:	04054163          	bltz	a0,80004994 <sys_write+0x5c>
    80004956:	fe440593          	addi	a1,s0,-28
    8000495a:	4509                	li	a0,2
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	91c080e7          	jalr	-1764(ra) # 80002278 <argint>
    return -1;
    80004964:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004966:	02054763          	bltz	a0,80004994 <sys_write+0x5c>
    8000496a:	fd840593          	addi	a1,s0,-40
    8000496e:	4505                	li	a0,1
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	92a080e7          	jalr	-1750(ra) # 8000229a <argaddr>
    return -1;
    80004978:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000497a:	00054d63          	bltz	a0,80004994 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000497e:	fe442603          	lw	a2,-28(s0)
    80004982:	fd843583          	ld	a1,-40(s0)
    80004986:	fe843503          	ld	a0,-24(s0)
    8000498a:	fffff097          	auipc	ra,0xfffff
    8000498e:	4fa080e7          	jalr	1274(ra) # 80003e84 <filewrite>
    80004992:	87aa                	mv	a5,a0
}
    80004994:	853e                	mv	a0,a5
    80004996:	70a2                	ld	ra,40(sp)
    80004998:	7402                	ld	s0,32(sp)
    8000499a:	6145                	addi	sp,sp,48
    8000499c:	8082                	ret

000000008000499e <sys_close>:
{
    8000499e:	1101                	addi	sp,sp,-32
    800049a0:	ec06                	sd	ra,24(sp)
    800049a2:	e822                	sd	s0,16(sp)
    800049a4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049a6:	fe040613          	addi	a2,s0,-32
    800049aa:	fec40593          	addi	a1,s0,-20
    800049ae:	4501                	li	a0,0
    800049b0:	00000097          	auipc	ra,0x0
    800049b4:	cc2080e7          	jalr	-830(ra) # 80004672 <argfd>
    return -1;
    800049b8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049ba:	02054463          	bltz	a0,800049e2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049be:	ffffc097          	auipc	ra,0xffffc
    800049c2:	4be080e7          	jalr	1214(ra) # 80000e7c <myproc>
    800049c6:	fec42783          	lw	a5,-20(s0)
    800049ca:	07e9                	addi	a5,a5,26
    800049cc:	078e                	slli	a5,a5,0x3
    800049ce:	97aa                	add	a5,a5,a0
    800049d0:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800049d4:	fe043503          	ld	a0,-32(s0)
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	2b0080e7          	jalr	688(ra) # 80003c88 <fileclose>
  return 0;
    800049e0:	4781                	li	a5,0
}
    800049e2:	853e                	mv	a0,a5
    800049e4:	60e2                	ld	ra,24(sp)
    800049e6:	6442                	ld	s0,16(sp)
    800049e8:	6105                	addi	sp,sp,32
    800049ea:	8082                	ret

00000000800049ec <sys_fstat>:
{
    800049ec:	1101                	addi	sp,sp,-32
    800049ee:	ec06                	sd	ra,24(sp)
    800049f0:	e822                	sd	s0,16(sp)
    800049f2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049f4:	fe840613          	addi	a2,s0,-24
    800049f8:	4581                	li	a1,0
    800049fa:	4501                	li	a0,0
    800049fc:	00000097          	auipc	ra,0x0
    80004a00:	c76080e7          	jalr	-906(ra) # 80004672 <argfd>
    return -1;
    80004a04:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a06:	02054563          	bltz	a0,80004a30 <sys_fstat+0x44>
    80004a0a:	fe040593          	addi	a1,s0,-32
    80004a0e:	4505                	li	a0,1
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	88a080e7          	jalr	-1910(ra) # 8000229a <argaddr>
    return -1;
    80004a18:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a1a:	00054b63          	bltz	a0,80004a30 <sys_fstat+0x44>
  return filestat(f, st);
    80004a1e:	fe043583          	ld	a1,-32(s0)
    80004a22:	fe843503          	ld	a0,-24(s0)
    80004a26:	fffff097          	auipc	ra,0xfffff
    80004a2a:	32a080e7          	jalr	810(ra) # 80003d50 <filestat>
    80004a2e:	87aa                	mv	a5,a0
}
    80004a30:	853e                	mv	a0,a5
    80004a32:	60e2                	ld	ra,24(sp)
    80004a34:	6442                	ld	s0,16(sp)
    80004a36:	6105                	addi	sp,sp,32
    80004a38:	8082                	ret

0000000080004a3a <sys_link>:
{
    80004a3a:	7169                	addi	sp,sp,-304
    80004a3c:	f606                	sd	ra,296(sp)
    80004a3e:	f222                	sd	s0,288(sp)
    80004a40:	ee26                	sd	s1,280(sp)
    80004a42:	ea4a                	sd	s2,272(sp)
    80004a44:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a46:	08000613          	li	a2,128
    80004a4a:	ed040593          	addi	a1,s0,-304
    80004a4e:	4501                	li	a0,0
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	86c080e7          	jalr	-1940(ra) # 800022bc <argstr>
    return -1;
    80004a58:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a5a:	10054e63          	bltz	a0,80004b76 <sys_link+0x13c>
    80004a5e:	08000613          	li	a2,128
    80004a62:	f5040593          	addi	a1,s0,-176
    80004a66:	4505                	li	a0,1
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	854080e7          	jalr	-1964(ra) # 800022bc <argstr>
    return -1;
    80004a70:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a72:	10054263          	bltz	a0,80004b76 <sys_link+0x13c>
  begin_op();
    80004a76:	fffff097          	auipc	ra,0xfffff
    80004a7a:	d46080e7          	jalr	-698(ra) # 800037bc <begin_op>
  if((ip = namei(old)) == 0){
    80004a7e:	ed040513          	addi	a0,s0,-304
    80004a82:	fffff097          	auipc	ra,0xfffff
    80004a86:	b1e080e7          	jalr	-1250(ra) # 800035a0 <namei>
    80004a8a:	84aa                	mv	s1,a0
    80004a8c:	c551                	beqz	a0,80004b18 <sys_link+0xde>
  ilock(ip);
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	35c080e7          	jalr	860(ra) # 80002dea <ilock>
  if(ip->type == T_DIR){
    80004a96:	04449703          	lh	a4,68(s1)
    80004a9a:	4785                	li	a5,1
    80004a9c:	08f70463          	beq	a4,a5,80004b24 <sys_link+0xea>
  ip->nlink++;
    80004aa0:	04a4d783          	lhu	a5,74(s1)
    80004aa4:	2785                	addiw	a5,a5,1
    80004aa6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffe097          	auipc	ra,0xffffe
    80004ab0:	274080e7          	jalr	628(ra) # 80002d20 <iupdate>
  iunlock(ip);
    80004ab4:	8526                	mv	a0,s1
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	3f6080e7          	jalr	1014(ra) # 80002eac <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004abe:	fd040593          	addi	a1,s0,-48
    80004ac2:	f5040513          	addi	a0,s0,-176
    80004ac6:	fffff097          	auipc	ra,0xfffff
    80004aca:	af8080e7          	jalr	-1288(ra) # 800035be <nameiparent>
    80004ace:	892a                	mv	s2,a0
    80004ad0:	c935                	beqz	a0,80004b44 <sys_link+0x10a>
  ilock(dp);
    80004ad2:	ffffe097          	auipc	ra,0xffffe
    80004ad6:	318080e7          	jalr	792(ra) # 80002dea <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ada:	00092703          	lw	a4,0(s2)
    80004ade:	409c                	lw	a5,0(s1)
    80004ae0:	04f71d63          	bne	a4,a5,80004b3a <sys_link+0x100>
    80004ae4:	40d0                	lw	a2,4(s1)
    80004ae6:	fd040593          	addi	a1,s0,-48
    80004aea:	854a                	mv	a0,s2
    80004aec:	fffff097          	auipc	ra,0xfffff
    80004af0:	9f2080e7          	jalr	-1550(ra) # 800034de <dirlink>
    80004af4:	04054363          	bltz	a0,80004b3a <sys_link+0x100>
  iunlockput(dp);
    80004af8:	854a                	mv	a0,s2
    80004afa:	ffffe097          	auipc	ra,0xffffe
    80004afe:	552080e7          	jalr	1362(ra) # 8000304c <iunlockput>
  iput(ip);
    80004b02:	8526                	mv	a0,s1
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	4a0080e7          	jalr	1184(ra) # 80002fa4 <iput>
  end_op();
    80004b0c:	fffff097          	auipc	ra,0xfffff
    80004b10:	d30080e7          	jalr	-720(ra) # 8000383c <end_op>
  return 0;
    80004b14:	4781                	li	a5,0
    80004b16:	a085                	j	80004b76 <sys_link+0x13c>
    end_op();
    80004b18:	fffff097          	auipc	ra,0xfffff
    80004b1c:	d24080e7          	jalr	-732(ra) # 8000383c <end_op>
    return -1;
    80004b20:	57fd                	li	a5,-1
    80004b22:	a891                	j	80004b76 <sys_link+0x13c>
    iunlockput(ip);
    80004b24:	8526                	mv	a0,s1
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	526080e7          	jalr	1318(ra) # 8000304c <iunlockput>
    end_op();
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	d0e080e7          	jalr	-754(ra) # 8000383c <end_op>
    return -1;
    80004b36:	57fd                	li	a5,-1
    80004b38:	a83d                	j	80004b76 <sys_link+0x13c>
    iunlockput(dp);
    80004b3a:	854a                	mv	a0,s2
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	510080e7          	jalr	1296(ra) # 8000304c <iunlockput>
  ilock(ip);
    80004b44:	8526                	mv	a0,s1
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	2a4080e7          	jalr	676(ra) # 80002dea <ilock>
  ip->nlink--;
    80004b4e:	04a4d783          	lhu	a5,74(s1)
    80004b52:	37fd                	addiw	a5,a5,-1
    80004b54:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b58:	8526                	mv	a0,s1
    80004b5a:	ffffe097          	auipc	ra,0xffffe
    80004b5e:	1c6080e7          	jalr	454(ra) # 80002d20 <iupdate>
  iunlockput(ip);
    80004b62:	8526                	mv	a0,s1
    80004b64:	ffffe097          	auipc	ra,0xffffe
    80004b68:	4e8080e7          	jalr	1256(ra) # 8000304c <iunlockput>
  end_op();
    80004b6c:	fffff097          	auipc	ra,0xfffff
    80004b70:	cd0080e7          	jalr	-816(ra) # 8000383c <end_op>
  return -1;
    80004b74:	57fd                	li	a5,-1
}
    80004b76:	853e                	mv	a0,a5
    80004b78:	70b2                	ld	ra,296(sp)
    80004b7a:	7412                	ld	s0,288(sp)
    80004b7c:	64f2                	ld	s1,280(sp)
    80004b7e:	6952                	ld	s2,272(sp)
    80004b80:	6155                	addi	sp,sp,304
    80004b82:	8082                	ret

0000000080004b84 <sys_unlink>:
{
    80004b84:	7151                	addi	sp,sp,-240
    80004b86:	f586                	sd	ra,232(sp)
    80004b88:	f1a2                	sd	s0,224(sp)
    80004b8a:	eda6                	sd	s1,216(sp)
    80004b8c:	e9ca                	sd	s2,208(sp)
    80004b8e:	e5ce                	sd	s3,200(sp)
    80004b90:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b92:	08000613          	li	a2,128
    80004b96:	f3040593          	addi	a1,s0,-208
    80004b9a:	4501                	li	a0,0
    80004b9c:	ffffd097          	auipc	ra,0xffffd
    80004ba0:	720080e7          	jalr	1824(ra) # 800022bc <argstr>
    80004ba4:	18054163          	bltz	a0,80004d26 <sys_unlink+0x1a2>
  begin_op();
    80004ba8:	fffff097          	auipc	ra,0xfffff
    80004bac:	c14080e7          	jalr	-1004(ra) # 800037bc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bb0:	fb040593          	addi	a1,s0,-80
    80004bb4:	f3040513          	addi	a0,s0,-208
    80004bb8:	fffff097          	auipc	ra,0xfffff
    80004bbc:	a06080e7          	jalr	-1530(ra) # 800035be <nameiparent>
    80004bc0:	84aa                	mv	s1,a0
    80004bc2:	c979                	beqz	a0,80004c98 <sys_unlink+0x114>
  ilock(dp);
    80004bc4:	ffffe097          	auipc	ra,0xffffe
    80004bc8:	226080e7          	jalr	550(ra) # 80002dea <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bcc:	00004597          	auipc	a1,0x4
    80004bd0:	aa458593          	addi	a1,a1,-1372 # 80008670 <syscalls+0x2c0>
    80004bd4:	fb040513          	addi	a0,s0,-80
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	6dc080e7          	jalr	1756(ra) # 800032b4 <namecmp>
    80004be0:	14050a63          	beqz	a0,80004d34 <sys_unlink+0x1b0>
    80004be4:	00004597          	auipc	a1,0x4
    80004be8:	a9458593          	addi	a1,a1,-1388 # 80008678 <syscalls+0x2c8>
    80004bec:	fb040513          	addi	a0,s0,-80
    80004bf0:	ffffe097          	auipc	ra,0xffffe
    80004bf4:	6c4080e7          	jalr	1732(ra) # 800032b4 <namecmp>
    80004bf8:	12050e63          	beqz	a0,80004d34 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bfc:	f2c40613          	addi	a2,s0,-212
    80004c00:	fb040593          	addi	a1,s0,-80
    80004c04:	8526                	mv	a0,s1
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	6c8080e7          	jalr	1736(ra) # 800032ce <dirlookup>
    80004c0e:	892a                	mv	s2,a0
    80004c10:	12050263          	beqz	a0,80004d34 <sys_unlink+0x1b0>
  ilock(ip);
    80004c14:	ffffe097          	auipc	ra,0xffffe
    80004c18:	1d6080e7          	jalr	470(ra) # 80002dea <ilock>
  if(ip->nlink < 1)
    80004c1c:	04a91783          	lh	a5,74(s2)
    80004c20:	08f05263          	blez	a5,80004ca4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c24:	04491703          	lh	a4,68(s2)
    80004c28:	4785                	li	a5,1
    80004c2a:	08f70563          	beq	a4,a5,80004cb4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c2e:	4641                	li	a2,16
    80004c30:	4581                	li	a1,0
    80004c32:	fc040513          	addi	a0,s0,-64
    80004c36:	ffffb097          	auipc	ra,0xffffb
    80004c3a:	542080e7          	jalr	1346(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c3e:	4741                	li	a4,16
    80004c40:	f2c42683          	lw	a3,-212(s0)
    80004c44:	fc040613          	addi	a2,s0,-64
    80004c48:	4581                	li	a1,0
    80004c4a:	8526                	mv	a0,s1
    80004c4c:	ffffe097          	auipc	ra,0xffffe
    80004c50:	54a080e7          	jalr	1354(ra) # 80003196 <writei>
    80004c54:	47c1                	li	a5,16
    80004c56:	0af51563          	bne	a0,a5,80004d00 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c5a:	04491703          	lh	a4,68(s2)
    80004c5e:	4785                	li	a5,1
    80004c60:	0af70863          	beq	a4,a5,80004d10 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c64:	8526                	mv	a0,s1
    80004c66:	ffffe097          	auipc	ra,0xffffe
    80004c6a:	3e6080e7          	jalr	998(ra) # 8000304c <iunlockput>
  ip->nlink--;
    80004c6e:	04a95783          	lhu	a5,74(s2)
    80004c72:	37fd                	addiw	a5,a5,-1
    80004c74:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c78:	854a                	mv	a0,s2
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	0a6080e7          	jalr	166(ra) # 80002d20 <iupdate>
  iunlockput(ip);
    80004c82:	854a                	mv	a0,s2
    80004c84:	ffffe097          	auipc	ra,0xffffe
    80004c88:	3c8080e7          	jalr	968(ra) # 8000304c <iunlockput>
  end_op();
    80004c8c:	fffff097          	auipc	ra,0xfffff
    80004c90:	bb0080e7          	jalr	-1104(ra) # 8000383c <end_op>
  return 0;
    80004c94:	4501                	li	a0,0
    80004c96:	a84d                	j	80004d48 <sys_unlink+0x1c4>
    end_op();
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	ba4080e7          	jalr	-1116(ra) # 8000383c <end_op>
    return -1;
    80004ca0:	557d                	li	a0,-1
    80004ca2:	a05d                	j	80004d48 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ca4:	00004517          	auipc	a0,0x4
    80004ca8:	9fc50513          	addi	a0,a0,-1540 # 800086a0 <syscalls+0x2f0>
    80004cac:	00001097          	auipc	ra,0x1
    80004cb0:	62c080e7          	jalr	1580(ra) # 800062d8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cb4:	04c92703          	lw	a4,76(s2)
    80004cb8:	02000793          	li	a5,32
    80004cbc:	f6e7f9e3          	bgeu	a5,a4,80004c2e <sys_unlink+0xaa>
    80004cc0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cc4:	4741                	li	a4,16
    80004cc6:	86ce                	mv	a3,s3
    80004cc8:	f1840613          	addi	a2,s0,-232
    80004ccc:	4581                	li	a1,0
    80004cce:	854a                	mv	a0,s2
    80004cd0:	ffffe097          	auipc	ra,0xffffe
    80004cd4:	3ce080e7          	jalr	974(ra) # 8000309e <readi>
    80004cd8:	47c1                	li	a5,16
    80004cda:	00f51b63          	bne	a0,a5,80004cf0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cde:	f1845783          	lhu	a5,-232(s0)
    80004ce2:	e7a1                	bnez	a5,80004d2a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ce4:	29c1                	addiw	s3,s3,16
    80004ce6:	04c92783          	lw	a5,76(s2)
    80004cea:	fcf9ede3          	bltu	s3,a5,80004cc4 <sys_unlink+0x140>
    80004cee:	b781                	j	80004c2e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cf0:	00004517          	auipc	a0,0x4
    80004cf4:	9c850513          	addi	a0,a0,-1592 # 800086b8 <syscalls+0x308>
    80004cf8:	00001097          	auipc	ra,0x1
    80004cfc:	5e0080e7          	jalr	1504(ra) # 800062d8 <panic>
    panic("unlink: writei");
    80004d00:	00004517          	auipc	a0,0x4
    80004d04:	9d050513          	addi	a0,a0,-1584 # 800086d0 <syscalls+0x320>
    80004d08:	00001097          	auipc	ra,0x1
    80004d0c:	5d0080e7          	jalr	1488(ra) # 800062d8 <panic>
    dp->nlink--;
    80004d10:	04a4d783          	lhu	a5,74(s1)
    80004d14:	37fd                	addiw	a5,a5,-1
    80004d16:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d1a:	8526                	mv	a0,s1
    80004d1c:	ffffe097          	auipc	ra,0xffffe
    80004d20:	004080e7          	jalr	4(ra) # 80002d20 <iupdate>
    80004d24:	b781                	j	80004c64 <sys_unlink+0xe0>
    return -1;
    80004d26:	557d                	li	a0,-1
    80004d28:	a005                	j	80004d48 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d2a:	854a                	mv	a0,s2
    80004d2c:	ffffe097          	auipc	ra,0xffffe
    80004d30:	320080e7          	jalr	800(ra) # 8000304c <iunlockput>
  iunlockput(dp);
    80004d34:	8526                	mv	a0,s1
    80004d36:	ffffe097          	auipc	ra,0xffffe
    80004d3a:	316080e7          	jalr	790(ra) # 8000304c <iunlockput>
  end_op();
    80004d3e:	fffff097          	auipc	ra,0xfffff
    80004d42:	afe080e7          	jalr	-1282(ra) # 8000383c <end_op>
  return -1;
    80004d46:	557d                	li	a0,-1
}
    80004d48:	70ae                	ld	ra,232(sp)
    80004d4a:	740e                	ld	s0,224(sp)
    80004d4c:	64ee                	ld	s1,216(sp)
    80004d4e:	694e                	ld	s2,208(sp)
    80004d50:	69ae                	ld	s3,200(sp)
    80004d52:	616d                	addi	sp,sp,240
    80004d54:	8082                	ret

0000000080004d56 <sys_open>:

uint64
sys_open(void)
{
    80004d56:	7131                	addi	sp,sp,-192
    80004d58:	fd06                	sd	ra,184(sp)
    80004d5a:	f922                	sd	s0,176(sp)
    80004d5c:	f526                	sd	s1,168(sp)
    80004d5e:	f14a                	sd	s2,160(sp)
    80004d60:	ed4e                	sd	s3,152(sp)
    80004d62:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d64:	08000613          	li	a2,128
    80004d68:	f5040593          	addi	a1,s0,-176
    80004d6c:	4501                	li	a0,0
    80004d6e:	ffffd097          	auipc	ra,0xffffd
    80004d72:	54e080e7          	jalr	1358(ra) # 800022bc <argstr>
    return -1;
    80004d76:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d78:	0c054163          	bltz	a0,80004e3a <sys_open+0xe4>
    80004d7c:	f4c40593          	addi	a1,s0,-180
    80004d80:	4505                	li	a0,1
    80004d82:	ffffd097          	auipc	ra,0xffffd
    80004d86:	4f6080e7          	jalr	1270(ra) # 80002278 <argint>
    80004d8a:	0a054863          	bltz	a0,80004e3a <sys_open+0xe4>

  begin_op();
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	a2e080e7          	jalr	-1490(ra) # 800037bc <begin_op>

  if(omode & O_CREATE){
    80004d96:	f4c42783          	lw	a5,-180(s0)
    80004d9a:	2007f793          	andi	a5,a5,512
    80004d9e:	cbdd                	beqz	a5,80004e54 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004da0:	4681                	li	a3,0
    80004da2:	4601                	li	a2,0
    80004da4:	4589                	li	a1,2
    80004da6:	f5040513          	addi	a0,s0,-176
    80004daa:	00000097          	auipc	ra,0x0
    80004dae:	972080e7          	jalr	-1678(ra) # 8000471c <create>
    80004db2:	892a                	mv	s2,a0
    if(ip == 0){
    80004db4:	c959                	beqz	a0,80004e4a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004db6:	04491703          	lh	a4,68(s2)
    80004dba:	478d                	li	a5,3
    80004dbc:	00f71763          	bne	a4,a5,80004dca <sys_open+0x74>
    80004dc0:	04695703          	lhu	a4,70(s2)
    80004dc4:	47a5                	li	a5,9
    80004dc6:	0ce7ec63          	bltu	a5,a4,80004e9e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dca:	fffff097          	auipc	ra,0xfffff
    80004dce:	e02080e7          	jalr	-510(ra) # 80003bcc <filealloc>
    80004dd2:	89aa                	mv	s3,a0
    80004dd4:	10050263          	beqz	a0,80004ed8 <sys_open+0x182>
    80004dd8:	00000097          	auipc	ra,0x0
    80004ddc:	902080e7          	jalr	-1790(ra) # 800046da <fdalloc>
    80004de0:	84aa                	mv	s1,a0
    80004de2:	0e054663          	bltz	a0,80004ece <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004de6:	04491703          	lh	a4,68(s2)
    80004dea:	478d                	li	a5,3
    80004dec:	0cf70463          	beq	a4,a5,80004eb4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004df0:	4789                	li	a5,2
    80004df2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004df6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dfa:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dfe:	f4c42783          	lw	a5,-180(s0)
    80004e02:	0017c713          	xori	a4,a5,1
    80004e06:	8b05                	andi	a4,a4,1
    80004e08:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e0c:	0037f713          	andi	a4,a5,3
    80004e10:	00e03733          	snez	a4,a4
    80004e14:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e18:	4007f793          	andi	a5,a5,1024
    80004e1c:	c791                	beqz	a5,80004e28 <sys_open+0xd2>
    80004e1e:	04491703          	lh	a4,68(s2)
    80004e22:	4789                	li	a5,2
    80004e24:	08f70f63          	beq	a4,a5,80004ec2 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e28:	854a                	mv	a0,s2
    80004e2a:	ffffe097          	auipc	ra,0xffffe
    80004e2e:	082080e7          	jalr	130(ra) # 80002eac <iunlock>
  end_op();
    80004e32:	fffff097          	auipc	ra,0xfffff
    80004e36:	a0a080e7          	jalr	-1526(ra) # 8000383c <end_op>

  return fd;
}
    80004e3a:	8526                	mv	a0,s1
    80004e3c:	70ea                	ld	ra,184(sp)
    80004e3e:	744a                	ld	s0,176(sp)
    80004e40:	74aa                	ld	s1,168(sp)
    80004e42:	790a                	ld	s2,160(sp)
    80004e44:	69ea                	ld	s3,152(sp)
    80004e46:	6129                	addi	sp,sp,192
    80004e48:	8082                	ret
      end_op();
    80004e4a:	fffff097          	auipc	ra,0xfffff
    80004e4e:	9f2080e7          	jalr	-1550(ra) # 8000383c <end_op>
      return -1;
    80004e52:	b7e5                	j	80004e3a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e54:	f5040513          	addi	a0,s0,-176
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	748080e7          	jalr	1864(ra) # 800035a0 <namei>
    80004e60:	892a                	mv	s2,a0
    80004e62:	c905                	beqz	a0,80004e92 <sys_open+0x13c>
    ilock(ip);
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	f86080e7          	jalr	-122(ra) # 80002dea <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e6c:	04491703          	lh	a4,68(s2)
    80004e70:	4785                	li	a5,1
    80004e72:	f4f712e3          	bne	a4,a5,80004db6 <sys_open+0x60>
    80004e76:	f4c42783          	lw	a5,-180(s0)
    80004e7a:	dba1                	beqz	a5,80004dca <sys_open+0x74>
      iunlockput(ip);
    80004e7c:	854a                	mv	a0,s2
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	1ce080e7          	jalr	462(ra) # 8000304c <iunlockput>
      end_op();
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	9b6080e7          	jalr	-1610(ra) # 8000383c <end_op>
      return -1;
    80004e8e:	54fd                	li	s1,-1
    80004e90:	b76d                	j	80004e3a <sys_open+0xe4>
      end_op();
    80004e92:	fffff097          	auipc	ra,0xfffff
    80004e96:	9aa080e7          	jalr	-1622(ra) # 8000383c <end_op>
      return -1;
    80004e9a:	54fd                	li	s1,-1
    80004e9c:	bf79                	j	80004e3a <sys_open+0xe4>
    iunlockput(ip);
    80004e9e:	854a                	mv	a0,s2
    80004ea0:	ffffe097          	auipc	ra,0xffffe
    80004ea4:	1ac080e7          	jalr	428(ra) # 8000304c <iunlockput>
    end_op();
    80004ea8:	fffff097          	auipc	ra,0xfffff
    80004eac:	994080e7          	jalr	-1644(ra) # 8000383c <end_op>
    return -1;
    80004eb0:	54fd                	li	s1,-1
    80004eb2:	b761                	j	80004e3a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004eb4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004eb8:	04691783          	lh	a5,70(s2)
    80004ebc:	02f99223          	sh	a5,36(s3)
    80004ec0:	bf2d                	j	80004dfa <sys_open+0xa4>
    itrunc(ip);
    80004ec2:	854a                	mv	a0,s2
    80004ec4:	ffffe097          	auipc	ra,0xffffe
    80004ec8:	034080e7          	jalr	52(ra) # 80002ef8 <itrunc>
    80004ecc:	bfb1                	j	80004e28 <sys_open+0xd2>
      fileclose(f);
    80004ece:	854e                	mv	a0,s3
    80004ed0:	fffff097          	auipc	ra,0xfffff
    80004ed4:	db8080e7          	jalr	-584(ra) # 80003c88 <fileclose>
    iunlockput(ip);
    80004ed8:	854a                	mv	a0,s2
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	172080e7          	jalr	370(ra) # 8000304c <iunlockput>
    end_op();
    80004ee2:	fffff097          	auipc	ra,0xfffff
    80004ee6:	95a080e7          	jalr	-1702(ra) # 8000383c <end_op>
    return -1;
    80004eea:	54fd                	li	s1,-1
    80004eec:	b7b9                	j	80004e3a <sys_open+0xe4>

0000000080004eee <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004eee:	7175                	addi	sp,sp,-144
    80004ef0:	e506                	sd	ra,136(sp)
    80004ef2:	e122                	sd	s0,128(sp)
    80004ef4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	8c6080e7          	jalr	-1850(ra) # 800037bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004efe:	08000613          	li	a2,128
    80004f02:	f7040593          	addi	a1,s0,-144
    80004f06:	4501                	li	a0,0
    80004f08:	ffffd097          	auipc	ra,0xffffd
    80004f0c:	3b4080e7          	jalr	948(ra) # 800022bc <argstr>
    80004f10:	02054963          	bltz	a0,80004f42 <sys_mkdir+0x54>
    80004f14:	4681                	li	a3,0
    80004f16:	4601                	li	a2,0
    80004f18:	4585                	li	a1,1
    80004f1a:	f7040513          	addi	a0,s0,-144
    80004f1e:	fffff097          	auipc	ra,0xfffff
    80004f22:	7fe080e7          	jalr	2046(ra) # 8000471c <create>
    80004f26:	cd11                	beqz	a0,80004f42 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	124080e7          	jalr	292(ra) # 8000304c <iunlockput>
  end_op();
    80004f30:	fffff097          	auipc	ra,0xfffff
    80004f34:	90c080e7          	jalr	-1780(ra) # 8000383c <end_op>
  return 0;
    80004f38:	4501                	li	a0,0
}
    80004f3a:	60aa                	ld	ra,136(sp)
    80004f3c:	640a                	ld	s0,128(sp)
    80004f3e:	6149                	addi	sp,sp,144
    80004f40:	8082                	ret
    end_op();
    80004f42:	fffff097          	auipc	ra,0xfffff
    80004f46:	8fa080e7          	jalr	-1798(ra) # 8000383c <end_op>
    return -1;
    80004f4a:	557d                	li	a0,-1
    80004f4c:	b7fd                	j	80004f3a <sys_mkdir+0x4c>

0000000080004f4e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f4e:	7135                	addi	sp,sp,-160
    80004f50:	ed06                	sd	ra,152(sp)
    80004f52:	e922                	sd	s0,144(sp)
    80004f54:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f56:	fffff097          	auipc	ra,0xfffff
    80004f5a:	866080e7          	jalr	-1946(ra) # 800037bc <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f5e:	08000613          	li	a2,128
    80004f62:	f7040593          	addi	a1,s0,-144
    80004f66:	4501                	li	a0,0
    80004f68:	ffffd097          	auipc	ra,0xffffd
    80004f6c:	354080e7          	jalr	852(ra) # 800022bc <argstr>
    80004f70:	04054a63          	bltz	a0,80004fc4 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f74:	f6c40593          	addi	a1,s0,-148
    80004f78:	4505                	li	a0,1
    80004f7a:	ffffd097          	auipc	ra,0xffffd
    80004f7e:	2fe080e7          	jalr	766(ra) # 80002278 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f82:	04054163          	bltz	a0,80004fc4 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f86:	f6840593          	addi	a1,s0,-152
    80004f8a:	4509                	li	a0,2
    80004f8c:	ffffd097          	auipc	ra,0xffffd
    80004f90:	2ec080e7          	jalr	748(ra) # 80002278 <argint>
     argint(1, &major) < 0 ||
    80004f94:	02054863          	bltz	a0,80004fc4 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f98:	f6841683          	lh	a3,-152(s0)
    80004f9c:	f6c41603          	lh	a2,-148(s0)
    80004fa0:	458d                	li	a1,3
    80004fa2:	f7040513          	addi	a0,s0,-144
    80004fa6:	fffff097          	auipc	ra,0xfffff
    80004faa:	776080e7          	jalr	1910(ra) # 8000471c <create>
     argint(2, &minor) < 0 ||
    80004fae:	c919                	beqz	a0,80004fc4 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fb0:	ffffe097          	auipc	ra,0xffffe
    80004fb4:	09c080e7          	jalr	156(ra) # 8000304c <iunlockput>
  end_op();
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	884080e7          	jalr	-1916(ra) # 8000383c <end_op>
  return 0;
    80004fc0:	4501                	li	a0,0
    80004fc2:	a031                	j	80004fce <sys_mknod+0x80>
    end_op();
    80004fc4:	fffff097          	auipc	ra,0xfffff
    80004fc8:	878080e7          	jalr	-1928(ra) # 8000383c <end_op>
    return -1;
    80004fcc:	557d                	li	a0,-1
}
    80004fce:	60ea                	ld	ra,152(sp)
    80004fd0:	644a                	ld	s0,144(sp)
    80004fd2:	610d                	addi	sp,sp,160
    80004fd4:	8082                	ret

0000000080004fd6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fd6:	7135                	addi	sp,sp,-160
    80004fd8:	ed06                	sd	ra,152(sp)
    80004fda:	e922                	sd	s0,144(sp)
    80004fdc:	e526                	sd	s1,136(sp)
    80004fde:	e14a                	sd	s2,128(sp)
    80004fe0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fe2:	ffffc097          	auipc	ra,0xffffc
    80004fe6:	e9a080e7          	jalr	-358(ra) # 80000e7c <myproc>
    80004fea:	892a                	mv	s2,a0
  
  begin_op();
    80004fec:	ffffe097          	auipc	ra,0xffffe
    80004ff0:	7d0080e7          	jalr	2000(ra) # 800037bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ff4:	08000613          	li	a2,128
    80004ff8:	f6040593          	addi	a1,s0,-160
    80004ffc:	4501                	li	a0,0
    80004ffe:	ffffd097          	auipc	ra,0xffffd
    80005002:	2be080e7          	jalr	702(ra) # 800022bc <argstr>
    80005006:	04054b63          	bltz	a0,8000505c <sys_chdir+0x86>
    8000500a:	f6040513          	addi	a0,s0,-160
    8000500e:	ffffe097          	auipc	ra,0xffffe
    80005012:	592080e7          	jalr	1426(ra) # 800035a0 <namei>
    80005016:	84aa                	mv	s1,a0
    80005018:	c131                	beqz	a0,8000505c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000501a:	ffffe097          	auipc	ra,0xffffe
    8000501e:	dd0080e7          	jalr	-560(ra) # 80002dea <ilock>
  if(ip->type != T_DIR){
    80005022:	04449703          	lh	a4,68(s1)
    80005026:	4785                	li	a5,1
    80005028:	04f71063          	bne	a4,a5,80005068 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000502c:	8526                	mv	a0,s1
    8000502e:	ffffe097          	auipc	ra,0xffffe
    80005032:	e7e080e7          	jalr	-386(ra) # 80002eac <iunlock>
  iput(p->cwd);
    80005036:	15093503          	ld	a0,336(s2)
    8000503a:	ffffe097          	auipc	ra,0xffffe
    8000503e:	f6a080e7          	jalr	-150(ra) # 80002fa4 <iput>
  end_op();
    80005042:	ffffe097          	auipc	ra,0xffffe
    80005046:	7fa080e7          	jalr	2042(ra) # 8000383c <end_op>
  p->cwd = ip;
    8000504a:	14993823          	sd	s1,336(s2)
  return 0;
    8000504e:	4501                	li	a0,0
}
    80005050:	60ea                	ld	ra,152(sp)
    80005052:	644a                	ld	s0,144(sp)
    80005054:	64aa                	ld	s1,136(sp)
    80005056:	690a                	ld	s2,128(sp)
    80005058:	610d                	addi	sp,sp,160
    8000505a:	8082                	ret
    end_op();
    8000505c:	ffffe097          	auipc	ra,0xffffe
    80005060:	7e0080e7          	jalr	2016(ra) # 8000383c <end_op>
    return -1;
    80005064:	557d                	li	a0,-1
    80005066:	b7ed                	j	80005050 <sys_chdir+0x7a>
    iunlockput(ip);
    80005068:	8526                	mv	a0,s1
    8000506a:	ffffe097          	auipc	ra,0xffffe
    8000506e:	fe2080e7          	jalr	-30(ra) # 8000304c <iunlockput>
    end_op();
    80005072:	ffffe097          	auipc	ra,0xffffe
    80005076:	7ca080e7          	jalr	1994(ra) # 8000383c <end_op>
    return -1;
    8000507a:	557d                	li	a0,-1
    8000507c:	bfd1                	j	80005050 <sys_chdir+0x7a>

000000008000507e <sys_exec>:

uint64
sys_exec(void)
{
    8000507e:	7145                	addi	sp,sp,-464
    80005080:	e786                	sd	ra,456(sp)
    80005082:	e3a2                	sd	s0,448(sp)
    80005084:	ff26                	sd	s1,440(sp)
    80005086:	fb4a                	sd	s2,432(sp)
    80005088:	f74e                	sd	s3,424(sp)
    8000508a:	f352                	sd	s4,416(sp)
    8000508c:	ef56                	sd	s5,408(sp)
    8000508e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005090:	08000613          	li	a2,128
    80005094:	f4040593          	addi	a1,s0,-192
    80005098:	4501                	li	a0,0
    8000509a:	ffffd097          	auipc	ra,0xffffd
    8000509e:	222080e7          	jalr	546(ra) # 800022bc <argstr>
    return -1;
    800050a2:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050a4:	0c054a63          	bltz	a0,80005178 <sys_exec+0xfa>
    800050a8:	e3840593          	addi	a1,s0,-456
    800050ac:	4505                	li	a0,1
    800050ae:	ffffd097          	auipc	ra,0xffffd
    800050b2:	1ec080e7          	jalr	492(ra) # 8000229a <argaddr>
    800050b6:	0c054163          	bltz	a0,80005178 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800050ba:	10000613          	li	a2,256
    800050be:	4581                	li	a1,0
    800050c0:	e4040513          	addi	a0,s0,-448
    800050c4:	ffffb097          	auipc	ra,0xffffb
    800050c8:	0b4080e7          	jalr	180(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050cc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050d0:	89a6                	mv	s3,s1
    800050d2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050d4:	02000a13          	li	s4,32
    800050d8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050dc:	00391513          	slli	a0,s2,0x3
    800050e0:	e3040593          	addi	a1,s0,-464
    800050e4:	e3843783          	ld	a5,-456(s0)
    800050e8:	953e                	add	a0,a0,a5
    800050ea:	ffffd097          	auipc	ra,0xffffd
    800050ee:	0f4080e7          	jalr	244(ra) # 800021de <fetchaddr>
    800050f2:	02054a63          	bltz	a0,80005126 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    800050f6:	e3043783          	ld	a5,-464(s0)
    800050fa:	c3b9                	beqz	a5,80005140 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050fc:	ffffb097          	auipc	ra,0xffffb
    80005100:	01c080e7          	jalr	28(ra) # 80000118 <kalloc>
    80005104:	85aa                	mv	a1,a0
    80005106:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000510a:	cd11                	beqz	a0,80005126 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000510c:	6605                	lui	a2,0x1
    8000510e:	e3043503          	ld	a0,-464(s0)
    80005112:	ffffd097          	auipc	ra,0xffffd
    80005116:	11e080e7          	jalr	286(ra) # 80002230 <fetchstr>
    8000511a:	00054663          	bltz	a0,80005126 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000511e:	0905                	addi	s2,s2,1
    80005120:	09a1                	addi	s3,s3,8
    80005122:	fb491be3          	bne	s2,s4,800050d8 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005126:	10048913          	addi	s2,s1,256
    8000512a:	6088                	ld	a0,0(s1)
    8000512c:	c529                	beqz	a0,80005176 <sys_exec+0xf8>
    kfree(argv[i]);
    8000512e:	ffffb097          	auipc	ra,0xffffb
    80005132:	eee080e7          	jalr	-274(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005136:	04a1                	addi	s1,s1,8
    80005138:	ff2499e3          	bne	s1,s2,8000512a <sys_exec+0xac>
  return -1;
    8000513c:	597d                	li	s2,-1
    8000513e:	a82d                	j	80005178 <sys_exec+0xfa>
      argv[i] = 0;
    80005140:	0a8e                	slli	s5,s5,0x3
    80005142:	fc040793          	addi	a5,s0,-64
    80005146:	9abe                	add	s5,s5,a5
    80005148:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000514c:	e4040593          	addi	a1,s0,-448
    80005150:	f4040513          	addi	a0,s0,-192
    80005154:	fffff097          	auipc	ra,0xfffff
    80005158:	194080e7          	jalr	404(ra) # 800042e8 <exec>
    8000515c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000515e:	10048993          	addi	s3,s1,256
    80005162:	6088                	ld	a0,0(s1)
    80005164:	c911                	beqz	a0,80005178 <sys_exec+0xfa>
    kfree(argv[i]);
    80005166:	ffffb097          	auipc	ra,0xffffb
    8000516a:	eb6080e7          	jalr	-330(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000516e:	04a1                	addi	s1,s1,8
    80005170:	ff3499e3          	bne	s1,s3,80005162 <sys_exec+0xe4>
    80005174:	a011                	j	80005178 <sys_exec+0xfa>
  return -1;
    80005176:	597d                	li	s2,-1
}
    80005178:	854a                	mv	a0,s2
    8000517a:	60be                	ld	ra,456(sp)
    8000517c:	641e                	ld	s0,448(sp)
    8000517e:	74fa                	ld	s1,440(sp)
    80005180:	795a                	ld	s2,432(sp)
    80005182:	79ba                	ld	s3,424(sp)
    80005184:	7a1a                	ld	s4,416(sp)
    80005186:	6afa                	ld	s5,408(sp)
    80005188:	6179                	addi	sp,sp,464
    8000518a:	8082                	ret

000000008000518c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000518c:	7139                	addi	sp,sp,-64
    8000518e:	fc06                	sd	ra,56(sp)
    80005190:	f822                	sd	s0,48(sp)
    80005192:	f426                	sd	s1,40(sp)
    80005194:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005196:	ffffc097          	auipc	ra,0xffffc
    8000519a:	ce6080e7          	jalr	-794(ra) # 80000e7c <myproc>
    8000519e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800051a0:	fd840593          	addi	a1,s0,-40
    800051a4:	4501                	li	a0,0
    800051a6:	ffffd097          	auipc	ra,0xffffd
    800051aa:	0f4080e7          	jalr	244(ra) # 8000229a <argaddr>
    return -1;
    800051ae:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800051b0:	0e054063          	bltz	a0,80005290 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800051b4:	fc840593          	addi	a1,s0,-56
    800051b8:	fd040513          	addi	a0,s0,-48
    800051bc:	fffff097          	auipc	ra,0xfffff
    800051c0:	dfc080e7          	jalr	-516(ra) # 80003fb8 <pipealloc>
    return -1;
    800051c4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051c6:	0c054563          	bltz	a0,80005290 <sys_pipe+0x104>
  fd0 = -1;
    800051ca:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051ce:	fd043503          	ld	a0,-48(s0)
    800051d2:	fffff097          	auipc	ra,0xfffff
    800051d6:	508080e7          	jalr	1288(ra) # 800046da <fdalloc>
    800051da:	fca42223          	sw	a0,-60(s0)
    800051de:	08054c63          	bltz	a0,80005276 <sys_pipe+0xea>
    800051e2:	fc843503          	ld	a0,-56(s0)
    800051e6:	fffff097          	auipc	ra,0xfffff
    800051ea:	4f4080e7          	jalr	1268(ra) # 800046da <fdalloc>
    800051ee:	fca42023          	sw	a0,-64(s0)
    800051f2:	06054863          	bltz	a0,80005262 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051f6:	4691                	li	a3,4
    800051f8:	fc440613          	addi	a2,s0,-60
    800051fc:	fd843583          	ld	a1,-40(s0)
    80005200:	68a8                	ld	a0,80(s1)
    80005202:	ffffc097          	auipc	ra,0xffffc
    80005206:	8ea080e7          	jalr	-1814(ra) # 80000aec <copyout>
    8000520a:	02054063          	bltz	a0,8000522a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000520e:	4691                	li	a3,4
    80005210:	fc040613          	addi	a2,s0,-64
    80005214:	fd843583          	ld	a1,-40(s0)
    80005218:	0591                	addi	a1,a1,4
    8000521a:	68a8                	ld	a0,80(s1)
    8000521c:	ffffc097          	auipc	ra,0xffffc
    80005220:	8d0080e7          	jalr	-1840(ra) # 80000aec <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005224:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005226:	06055563          	bgez	a0,80005290 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000522a:	fc442783          	lw	a5,-60(s0)
    8000522e:	07e9                	addi	a5,a5,26
    80005230:	078e                	slli	a5,a5,0x3
    80005232:	97a6                	add	a5,a5,s1
    80005234:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005238:	fc042503          	lw	a0,-64(s0)
    8000523c:	0569                	addi	a0,a0,26
    8000523e:	050e                	slli	a0,a0,0x3
    80005240:	9526                	add	a0,a0,s1
    80005242:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005246:	fd043503          	ld	a0,-48(s0)
    8000524a:	fffff097          	auipc	ra,0xfffff
    8000524e:	a3e080e7          	jalr	-1474(ra) # 80003c88 <fileclose>
    fileclose(wf);
    80005252:	fc843503          	ld	a0,-56(s0)
    80005256:	fffff097          	auipc	ra,0xfffff
    8000525a:	a32080e7          	jalr	-1486(ra) # 80003c88 <fileclose>
    return -1;
    8000525e:	57fd                	li	a5,-1
    80005260:	a805                	j	80005290 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005262:	fc442783          	lw	a5,-60(s0)
    80005266:	0007c863          	bltz	a5,80005276 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000526a:	01a78513          	addi	a0,a5,26
    8000526e:	050e                	slli	a0,a0,0x3
    80005270:	9526                	add	a0,a0,s1
    80005272:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005276:	fd043503          	ld	a0,-48(s0)
    8000527a:	fffff097          	auipc	ra,0xfffff
    8000527e:	a0e080e7          	jalr	-1522(ra) # 80003c88 <fileclose>
    fileclose(wf);
    80005282:	fc843503          	ld	a0,-56(s0)
    80005286:	fffff097          	auipc	ra,0xfffff
    8000528a:	a02080e7          	jalr	-1534(ra) # 80003c88 <fileclose>
    return -1;
    8000528e:	57fd                	li	a5,-1
}
    80005290:	853e                	mv	a0,a5
    80005292:	70e2                	ld	ra,56(sp)
    80005294:	7442                	ld	s0,48(sp)
    80005296:	74a2                	ld	s1,40(sp)
    80005298:	6121                	addi	sp,sp,64
    8000529a:	8082                	ret

000000008000529c <sys_mmap>:
uint64 
sys_mmap(void) {
    8000529c:	7139                	addi	sp,sp,-64
    8000529e:	fc06                	sd	ra,56(sp)
    800052a0:	f822                	sd	s0,48(sp)
    800052a2:	f426                	sd	s1,40(sp)
    800052a4:	0080                	addi	s0,sp,64
  uint64 addr;
  int len, prot, flags, offset;
  struct file *f;
  struct vm_area *vma = 0;
  struct proc *p = myproc();
    800052a6:	ffffc097          	auipc	ra,0xffffc
    800052aa:	bd6080e7          	jalr	-1066(ra) # 80000e7c <myproc>
    800052ae:	84aa                	mv	s1,a0
  int i;
//提取系统调用参数
  if (argaddr(0, &addr) < 0 || argint(1, &len) < 0
    800052b0:	fd840593          	addi	a1,s0,-40
    800052b4:	4501                	li	a0,0
    800052b6:	ffffd097          	auipc	ra,0xffffd
    800052ba:	fe4080e7          	jalr	-28(ra) # 8000229a <argaddr>
      || argint(2, &prot) < 0 || argint(3, &flags) < 0
      || argfd(4, 0, &f) < 0 || argint(5, &offset) < 0) {
    return -1;
    800052be:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0 || argint(1, &len) < 0
    800052c0:	14054863          	bltz	a0,80005410 <sys_mmap+0x174>
    800052c4:	fd440593          	addi	a1,s0,-44
    800052c8:	4505                	li	a0,1
    800052ca:	ffffd097          	auipc	ra,0xffffd
    800052ce:	fae080e7          	jalr	-82(ra) # 80002278 <argint>
    return -1;
    800052d2:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0 || argint(1, &len) < 0
    800052d4:	12054e63          	bltz	a0,80005410 <sys_mmap+0x174>
      || argint(2, &prot) < 0 || argint(3, &flags) < 0
    800052d8:	fd040593          	addi	a1,s0,-48
    800052dc:	4509                	li	a0,2
    800052de:	ffffd097          	auipc	ra,0xffffd
    800052e2:	f9a080e7          	jalr	-102(ra) # 80002278 <argint>
    return -1;
    800052e6:	57fd                	li	a5,-1
      || argint(2, &prot) < 0 || argint(3, &flags) < 0
    800052e8:	12054463          	bltz	a0,80005410 <sys_mmap+0x174>
    800052ec:	fcc40593          	addi	a1,s0,-52
    800052f0:	450d                	li	a0,3
    800052f2:	ffffd097          	auipc	ra,0xffffd
    800052f6:	f86080e7          	jalr	-122(ra) # 80002278 <argint>
    return -1;
    800052fa:	57fd                	li	a5,-1
      || argint(2, &prot) < 0 || argint(3, &flags) < 0
    800052fc:	10054a63          	bltz	a0,80005410 <sys_mmap+0x174>
      || argfd(4, 0, &f) < 0 || argint(5, &offset) < 0) {
    80005300:	fc040613          	addi	a2,s0,-64
    80005304:	4581                	li	a1,0
    80005306:	4511                	li	a0,4
    80005308:	fffff097          	auipc	ra,0xfffff
    8000530c:	36a080e7          	jalr	874(ra) # 80004672 <argfd>
    return -1;
    80005310:	57fd                	li	a5,-1
      || argfd(4, 0, &f) < 0 || argint(5, &offset) < 0) {
    80005312:	0e054f63          	bltz	a0,80005410 <sys_mmap+0x174>
    80005316:	fc840593          	addi	a1,s0,-56
    8000531a:	4515                	li	a0,5
    8000531c:	ffffd097          	auipc	ra,0xffffd
    80005320:	f5c080e7          	jalr	-164(ra) # 80002278 <argint>
    80005324:	0e054c63          	bltz	a0,8000541c <sys_mmap+0x180>
  }
  if (flags != MAP_SHARED && flags != MAP_PRIVATE) {
    80005328:	fcc42883          	lw	a7,-52(s0)
    8000532c:	fff8869b          	addiw	a3,a7,-1
    80005330:	4705                	li	a4,1
    return -1;
    80005332:	57fd                	li	a5,-1
  if (flags != MAP_SHARED && flags != MAP_PRIVATE) {
    80005334:	0cd76e63          	bltu	a4,a3,80005410 <sys_mmap+0x174>
  }
// 如果使用 MAP_SHARED 标志，文件必须是可写的
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) {
    80005338:	4785                	li	a5,1
    8000533a:	02f88c63          	beq	a7,a5,80005372 <sys_mmap+0xd6>
    return -1;
  }
// 偏移量必须是页面大小的整数倍
  if (len < 0 || offset < 0 || offset % PGSIZE) {
    8000533e:	fd442303          	lw	t1,-44(s0)
    80005342:	0c034f63          	bltz	t1,80005420 <sys_mmap+0x184>
    80005346:	fc842e03          	lw	t3,-56(s0)
    8000534a:	0c0e4d63          	bltz	t3,80005424 <sys_mmap+0x188>
    8000534e:	034e1713          	slli	a4,t3,0x34
    return -1;
    80005352:	57fd                	li	a5,-1
  if (len < 0 || offset < 0 || offset % PGSIZE) {
    80005354:	ef55                	bnez	a4,80005410 <sys_mmap+0x174>
    80005356:	16848793          	addi	a5,s1,360
    8000535a:	873e                	mv	a4,a5
  }

   // 为映射的内存分配一个 VMA
  for (i = 0; i < NVMA; ++i) {
    8000535c:	4601                	li	a2,0
    8000535e:	45c1                	li	a1,16
    if (!p->vma[i].addr) {
    80005360:	6314                	ld	a3,0(a4)
    80005362:	c29d                	beqz	a3,80005388 <sys_mmap+0xec>
  for (i = 0; i < NVMA; ++i) {
    80005364:	2605                	addiw	a2,a2,1
    80005366:	02070713          	addi	a4,a4,32
    8000536a:	feb61be3          	bne	a2,a1,80005360 <sys_mmap+0xc4>
      vma = &p->vma[i];
      break;
    }
  }
  if (!vma) {
    return -1;
    8000536e:	57fd                	li	a5,-1
    80005370:	a045                	j	80005410 <sys_mmap+0x174>
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) {
    80005372:	fc043783          	ld	a5,-64(s0)
    80005376:	0097c783          	lbu	a5,9(a5)
    8000537a:	f3f1                	bnez	a5,8000533e <sys_mmap+0xa2>
    8000537c:	fd042703          	lw	a4,-48(s0)
    80005380:	8b09                	andi	a4,a4,2
    return -1;
    80005382:	57fd                	li	a5,-1
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) {
    80005384:	df4d                	beqz	a4,8000533e <sys_mmap+0xa2>
    80005386:	a069                	j	80005410 <sys_mmap+0x174>
  }

  // 假设 addr 始终为 0，内核选择一个页面对齐的地址来创建映射
  addr = MMAPMINADDR;
    80005388:	010005b7          	lui	a1,0x1000
    8000538c:	15f5                	addi	a1,a1,-3
    8000538e:	05ba                	slli	a1,a1,0xe
    80005390:	fcb43c23          	sd	a1,-40(s0)
  for (i = 0; i < NVMA; ++i) {
    80005394:	36848513          	addi	a0,s1,872
    if (p->vma[i].addr) {
      // 获取已映射内存的最大地址  
      addr = max(addr, p->vma[i].addr + p->vma[i].len);
    80005398:	4805                	li	a6,1
    8000539a:	a031                	j	800053a6 <sys_mmap+0x10a>
    8000539c:	86c2                	mv	a3,a6
  for (i = 0; i < NVMA; ++i) {
    8000539e:	02078793          	addi	a5,a5,32
    800053a2:	00a78a63          	beq	a5,a0,800053b6 <sys_mmap+0x11a>
    if (p->vma[i].addr) {
    800053a6:	6398                	ld	a4,0(a5)
    800053a8:	db7d                	beqz	a4,8000539e <sys_mmap+0x102>
      addr = max(addr, p->vma[i].addr + p->vma[i].len);
    800053aa:	4794                	lw	a3,8(a5)
    800053ac:	9736                	add	a4,a4,a3
    800053ae:	fee5f7e3          	bgeu	a1,a4,8000539c <sys_mmap+0x100>
    800053b2:	85ba                	mv	a1,a4
    800053b4:	b7e5                	j	8000539c <sys_mmap+0x100>
    800053b6:	c299                	beqz	a3,800053bc <sys_mmap+0x120>
    800053b8:	fcb43c23          	sd	a1,-40(s0)
    }
  }
  addr = PGROUNDUP(addr);// 将地址向上对齐到页面大小
    800053bc:	fd843703          	ld	a4,-40(s0)
    800053c0:	6785                	lui	a5,0x1
    800053c2:	17fd                	addi	a5,a5,-1
    800053c4:	973e                	add	a4,a4,a5
    800053c6:	77fd                	lui	a5,0xfffff
    800053c8:	8f7d                	and	a4,a4,a5
    800053ca:	fce43c23          	sd	a4,-40(s0)
  if (addr + len > TRAPFRAME) {// 检查是否超出允许的地址范围
    800053ce:	00e305b3          	add	a1,t1,a4
    800053d2:	020006b7          	lui	a3,0x2000
    800053d6:	16fd                	addi	a3,a3,-1
    800053d8:	06b6                	slli	a3,a3,0xd
    return -1;
    800053da:	57fd                	li	a5,-1
  if (addr + len > TRAPFRAME) {// 检查是否超出允许的地址范围
    800053dc:	02b6ea63          	bltu	a3,a1,80005410 <sys_mmap+0x174>
  }
  // 设置 VMA 的各个字段
  vma->addr = addr;   
    800053e0:	0616                	slli	a2,a2,0x5
    800053e2:	9626                	add	a2,a2,s1
    800053e4:	16e63423          	sd	a4,360(a2) # 1168 <_entry-0x7fffee98>
  vma->len = len;
    800053e8:	16662823          	sw	t1,368(a2)
  vma->prot = prot;
    800053ec:	fd042783          	lw	a5,-48(s0)
    800053f0:	16f62a23          	sw	a5,372(a2)
  vma->flags = flags;
    800053f4:	17162c23          	sw	a7,376(a2)
  vma->offset = offset;
    800053f8:	17c62e23          	sw	t3,380(a2)
  vma->f = f;
    800053fc:	fc043503          	ld	a0,-64(s0)
    80005400:	18a63023          	sd	a0,384(a2)
  filedup(f);     // 增加文件的引用计数
    80005404:	fffff097          	auipc	ra,0xfffff
    80005408:	832080e7          	jalr	-1998(ra) # 80003c36 <filedup>

  return addr;
    8000540c:	fd843783          	ld	a5,-40(s0)
}
    80005410:	853e                	mv	a0,a5
    80005412:	70e2                	ld	ra,56(sp)
    80005414:	7442                	ld	s0,48(sp)
    80005416:	74a2                	ld	s1,40(sp)
    80005418:	6121                	addi	sp,sp,64
    8000541a:	8082                	ret
    return -1;
    8000541c:	57fd                	li	a5,-1
    8000541e:	bfcd                	j	80005410 <sys_mmap+0x174>
    return -1;
    80005420:	57fd                	li	a5,-1
    80005422:	b7fd                	j	80005410 <sys_mmap+0x174>
    80005424:	57fd                	li	a5,-1
    80005426:	b7ed                	j	80005410 <sys_mmap+0x174>

0000000080005428 <sys_munmap>:

uint64 
sys_munmap(void) {
    80005428:	7175                	addi	sp,sp,-144
    8000542a:	e506                	sd	ra,136(sp)
    8000542c:	e122                	sd	s0,128(sp)
    8000542e:	fca6                	sd	s1,120(sp)
    80005430:	f8ca                	sd	s2,112(sp)
    80005432:	f4ce                	sd	s3,104(sp)
    80005434:	f0d2                	sd	s4,96(sp)
    80005436:	ecd6                	sd	s5,88(sp)
    80005438:	e8da                	sd	s6,80(sp)
    8000543a:	e4de                	sd	s7,72(sp)
    8000543c:	e0e2                	sd	s8,64(sp)
    8000543e:	fc66                	sd	s9,56(sp)
    80005440:	f86a                	sd	s10,48(sp)
    80005442:	f46e                	sd	s11,40(sp)
    80005444:	0900                	addi	s0,sp,144
  uint64 addr, va;
  int len;
  struct proc *p = myproc();
    80005446:	ffffc097          	auipc	ra,0xffffc
    8000544a:	a36080e7          	jalr	-1482(ra) # 80000e7c <myproc>
    8000544e:	84aa                	mv	s1,a0
    80005450:	f6a43c23          	sd	a0,-136(s0)
  struct vm_area *vma = 0;
  uint maxsz, n, n1;
  int i;

  if (argaddr(0, &addr) < 0 || argint(1, &len) < 0) {
    80005454:	f8840593          	addi	a1,s0,-120
    80005458:	4501                	li	a0,0
    8000545a:	ffffd097          	auipc	ra,0xffffd
    8000545e:	e40080e7          	jalr	-448(ra) # 8000229a <argaddr>
    80005462:	26054163          	bltz	a0,800056c4 <sys_munmap+0x29c>
    80005466:	f8440593          	addi	a1,s0,-124
    8000546a:	4505                	li	a0,1
    8000546c:	ffffd097          	auipc	ra,0xffffd
    80005470:	e0c080e7          	jalr	-500(ra) # 80002278 <argint>
    80005474:	24054a63          	bltz	a0,800056c8 <sys_munmap+0x2a0>
    return -1;
  }
  if (addr % PGSIZE || len < 0) {
    80005478:	f8843a03          	ld	s4,-120(s0)
    8000547c:	034a1793          	slli	a5,s4,0x34
    80005480:	0347dd13          	srli	s10,a5,0x34
    80005484:	24079463          	bnez	a5,800056cc <sys_munmap+0x2a4>
    80005488:	f8442503          	lw	a0,-124(s0)
    8000548c:	24054263          	bltz	a0,800056d0 <sys_munmap+0x2a8>
    80005490:	16848793          	addi	a5,s1,360
    return -1;
  }

  // 遍历当前进程的 VMA 列表，找到包含 addr 和 addr + len 的 VMA。
  //如果未找到合适的 VMA，返回错误。
  for (i = 0; i < NVMA; ++i) {
    80005494:	4481                	li	s1,0
    if (p->vma[i].addr && addr >= p->vma[i].addr
        && addr + len <= p->vma[i].addr + p->vma[i].len) {
    80005496:	014505b3          	add	a1,a0,s4
  for (i = 0; i < NVMA; ++i) {
    8000549a:	4641                	li	a2,16
    8000549c:	a031                	j	800054a8 <sys_munmap+0x80>
    8000549e:	2485                	addiw	s1,s1,1
    800054a0:	02078793          	addi	a5,a5,32 # fffffffffffff020 <end+0xffffffff7ffd0de0>
    800054a4:	04c48263          	beq	s1,a2,800054e8 <sys_munmap+0xc0>
    if (p->vma[i].addr && addr >= p->vma[i].addr
    800054a8:	6398                	ld	a4,0(a5)
    800054aa:	db75                	beqz	a4,8000549e <sys_munmap+0x76>
    800054ac:	feea69e3          	bltu	s4,a4,8000549e <sys_munmap+0x76>
        && addr + len <= p->vma[i].addr + p->vma[i].len) {
    800054b0:	4794                	lw	a3,8(a5)
    800054b2:	9736                	add	a4,a4,a3
    800054b4:	feb765e3          	bltu	a4,a1,8000549e <sys_munmap+0x76>
  }
  if (!vma) {
    return -1;
  }

  if (len == 0) {
    800054b8:	c90d                	beqz	a0,800054ea <sys_munmap+0xc2>
    return 0;
  }
// 如果映射类型是 MAP_SHARED，则需要将脏页写回到文件。
// 计算一次性可以写入磁盘的最大大小 maxsz。
// 遍历映射的每一页，如果该页是脏页，则将其写回文件。
  if ((vma->flags & MAP_SHARED)) {
    800054ba:	00549793          	slli	a5,s1,0x5
    800054be:	f7843703          	ld	a4,-136(s0)
    800054c2:	97ba                	add	a5,a5,a4
    800054c4:	1787a783          	lw	a5,376(a5)
    800054c8:	8b85                	andi	a5,a5,1
    800054ca:	12078963          	beqz	a5,800055fc <sys_munmap+0x1d4>
    maxsz = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    for (va = addr; va < addr + len; va += PGSIZE) {
    800054ce:	12ba7763          	bgeu	s4,a1,800055fc <sys_munmap+0x1d4>
      if (uvmgetdirty(p->pagetable, va) == 0) {
        continue;
      }
      n = min(PGSIZE, addr + len - va);
      for (i = 0; i < n; i += n1) {
        n1 = min(maxsz, n - i);
    800054d2:	6785                	lui	a5,0x1
    800054d4:	c0078d93          	addi	s11,a5,-1024 # c00 <_entry-0x7ffff400>
        begin_op();
        ilock(vma->f->ip);
    800054d8:	00549b13          	slli	s6,s1,0x5
    800054dc:	9b3a                	add	s6,s6,a4
        if (writei(vma->f->ip, 1, va + i, va - vma->addr + vma->offset + i, n1) != n1) {
    800054de:	00b48c93          	addi	s9,s1,11
    800054e2:	0c96                	slli	s9,s9,0x5
    800054e4:	9cba                	add	s9,s9,a4
    800054e6:	a8e1                	j	800055be <sys_munmap+0x196>
    return -1;
    800054e8:	5d7d                	li	s10,-1
    vma->len -= len;
  } else {
    panic("unexpected munmap");
  }
  return 0;
    800054ea:	856a                	mv	a0,s10
    800054ec:	60aa                	ld	ra,136(sp)
    800054ee:	640a                	ld	s0,128(sp)
    800054f0:	74e6                	ld	s1,120(sp)
    800054f2:	7946                	ld	s2,112(sp)
    800054f4:	79a6                	ld	s3,104(sp)
    800054f6:	7a06                	ld	s4,96(sp)
    800054f8:	6ae6                	ld	s5,88(sp)
    800054fa:	6b46                	ld	s6,80(sp)
    800054fc:	6ba6                	ld	s7,72(sp)
    800054fe:	6c06                	ld	s8,64(sp)
    80005500:	7ce2                	ld	s9,56(sp)
    80005502:	7d42                	ld	s10,48(sp)
    80005504:	7da2                	ld	s11,40(sp)
    80005506:	6149                	addi	sp,sp,144
    80005508:	8082                	ret
        n1 = min(maxsz, n - i);
    8000550a:	0009099b          	sext.w	s3,s2
        begin_op();
    8000550e:	ffffe097          	auipc	ra,0xffffe
    80005512:	2ae080e7          	jalr	686(ra) # 800037bc <begin_op>
        ilock(vma->f->ip);
    80005516:	180b3783          	ld	a5,384(s6)
    8000551a:	6f88                	ld	a0,24(a5)
    8000551c:	ffffe097          	auipc	ra,0xffffe
    80005520:	8ce080e7          	jalr	-1842(ra) # 80002dea <ilock>
        if (writei(vma->f->ip, 1, va + i, va - vma->addr + vma->offset + i, n1) != n1) {
    80005524:	008cb783          	ld	a5,8(s9)
    80005528:	17cb2683          	lw	a3,380(s6)
    8000552c:	9e9d                	subw	a3,a3,a5
    8000552e:	014686bb          	addw	a3,a3,s4
    80005532:	180b3783          	ld	a5,384(s6)
    80005536:	874e                	mv	a4,s3
    80005538:	015686bb          	addw	a3,a3,s5
    8000553c:	014c0633          	add	a2,s8,s4
    80005540:	4585                	li	a1,1
    80005542:	6f88                	ld	a0,24(a5)
    80005544:	ffffe097          	auipc	ra,0xffffe
    80005548:	c52080e7          	jalr	-942(ra) # 80003196 <writei>
    8000554c:	2501                	sext.w	a0,a0
    8000554e:	03351d63          	bne	a0,s3,80005588 <sys_munmap+0x160>
        iunlock(vma->f->ip);
    80005552:	180b3783          	ld	a5,384(s6)
    80005556:	6f88                	ld	a0,24(a5)
    80005558:	ffffe097          	auipc	ra,0xffffe
    8000555c:	954080e7          	jalr	-1708(ra) # 80002eac <iunlock>
        end_op();
    80005560:	ffffe097          	auipc	ra,0xffffe
    80005564:	2dc080e7          	jalr	732(ra) # 8000383c <end_op>
      for (i = 0; i < n; i += n1) {
    80005568:	0159093b          	addw	s2,s2,s5
    8000556c:	00090a9b          	sext.w	s5,s2
    80005570:	8c56                	mv	s8,s5
    80005572:	037afd63          	bgeu	s5,s7,800055ac <sys_munmap+0x184>
        n1 = min(maxsz, n - i);
    80005576:	415b893b          	subw	s2,s7,s5
    8000557a:	0009079b          	sext.w	a5,s2
    8000557e:	f8fdf6e3          	bgeu	s11,a5,8000550a <sys_munmap+0xe2>
    80005582:	f7442903          	lw	s2,-140(s0)
    80005586:	b751                	j	8000550a <sys_munmap+0xe2>
          iunlock(vma->f->ip);
    80005588:	0496                	slli	s1,s1,0x5
    8000558a:	f7843783          	ld	a5,-136(s0)
    8000558e:	00978533          	add	a0,a5,s1
    80005592:	18053783          	ld	a5,384(a0)
    80005596:	6f88                	ld	a0,24(a5)
    80005598:	ffffe097          	auipc	ra,0xffffe
    8000559c:	914080e7          	jalr	-1772(ra) # 80002eac <iunlock>
          end_op();
    800055a0:	ffffe097          	auipc	ra,0xffffe
    800055a4:	29c080e7          	jalr	668(ra) # 8000383c <end_op>
          return -1;
    800055a8:	5d7d                	li	s10,-1
    800055aa:	b781                	j	800054ea <sys_munmap+0xc2>
    for (va = addr; va < addr + len; va += PGSIZE) {
    800055ac:	6785                	lui	a5,0x1
    800055ae:	9a3e                	add	s4,s4,a5
    800055b0:	f8442783          	lw	a5,-124(s0)
    800055b4:	f8843703          	ld	a4,-120(s0)
    800055b8:	97ba                	add	a5,a5,a4
    800055ba:	04fa7163          	bgeu	s4,a5,800055fc <sys_munmap+0x1d4>
      if (uvmgetdirty(p->pagetable, va) == 0) {
    800055be:	85d2                	mv	a1,s4
    800055c0:	f7843783          	ld	a5,-136(s0)
    800055c4:	6ba8                	ld	a0,80(a5)
    800055c6:	ffffb097          	auipc	ra,0xffffb
    800055ca:	6f2080e7          	jalr	1778(ra) # 80000cb8 <uvmgetdirty>
    800055ce:	dd79                	beqz	a0,800055ac <sys_munmap+0x184>
      n = min(PGSIZE, addr + len - va);
    800055d0:	f8442b83          	lw	s7,-124(s0)
    800055d4:	f8843783          	ld	a5,-120(s0)
    800055d8:	9bbe                	add	s7,s7,a5
    800055da:	414b8bb3          	sub	s7,s7,s4
    800055de:	6785                	lui	a5,0x1
    800055e0:	0177f363          	bgeu	a5,s7,800055e6 <sys_munmap+0x1be>
    800055e4:	6b85                	lui	s7,0x1
    800055e6:	2b81                	sext.w	s7,s7
      for (i = 0; i < n; i += n1) {
    800055e8:	fc0b82e3          	beqz	s7,800055ac <sys_munmap+0x184>
    800055ec:	4c01                	li	s8,0
    800055ee:	4a81                	li	s5,0
        n1 = min(maxsz, n - i);
    800055f0:	6785                	lui	a5,0x1
    800055f2:	c007879b          	addiw	a5,a5,-1024
    800055f6:	f6f42a23          	sw	a5,-140(s0)
    800055fa:	bfb5                	j	80005576 <sys_munmap+0x14e>
  uvmunmap(p->pagetable, addr, (len - 1) / PGSIZE + 1, 1);
    800055fc:	f8442603          	lw	a2,-124(s0)
    80005600:	fff6079b          	addiw	a5,a2,-1
    80005604:	41f7d61b          	sraiw	a2,a5,0x1f
    80005608:	0146561b          	srliw	a2,a2,0x14
    8000560c:	9e3d                	addw	a2,a2,a5
    8000560e:	40c6561b          	sraiw	a2,a2,0xc
    80005612:	4685                	li	a3,1
    80005614:	2605                	addiw	a2,a2,1
    80005616:	f8843583          	ld	a1,-120(s0)
    8000561a:	f7843903          	ld	s2,-136(s0)
    8000561e:	05093503          	ld	a0,80(s2)
    80005622:	ffffb097          	auipc	ra,0xffffb
    80005626:	0ec080e7          	jalr	236(ra) # 8000070e <uvmunmap>
  if (addr == vma->addr && len == vma->len) {
    8000562a:	00549793          	slli	a5,s1,0x5
    8000562e:	97ca                	add	a5,a5,s2
    80005630:	1687b703          	ld	a4,360(a5) # 1168 <_entry-0x7fffee98>
    80005634:	f8843683          	ld	a3,-120(s0)
    80005638:	00d70e63          	beq	a4,a3,80005654 <sys_munmap+0x22c>
  } else if (addr + len == vma->addr + vma->len) {
    8000563c:	f8442583          	lw	a1,-124(s0)
    80005640:	1707a603          	lw	a2,368(a5)
    80005644:	96ae                	add	a3,a3,a1
    80005646:	9732                	add	a4,a4,a2
    80005648:	06e69663          	bne	a3,a4,800056b4 <sys_munmap+0x28c>
    vma->len -= len;
    8000564c:	9e0d                	subw	a2,a2,a1
    8000564e:	16c7a823          	sw	a2,368(a5)
    80005652:	bd61                	j	800054ea <sys_munmap+0xc2>
  if (addr == vma->addr && len == vma->len) {
    80005654:	f8442683          	lw	a3,-124(s0)
    80005658:	1707a603          	lw	a2,368(a5)
    8000565c:	02d60563          	beq	a2,a3,80005686 <sys_munmap+0x25e>
    vma->addr += len;
    80005660:	9736                	add	a4,a4,a3
    80005662:	16e7b423          	sd	a4,360(a5)
    vma->offset += len;
    80005666:	0496                	slli	s1,s1,0x5
    80005668:	f7843703          	ld	a4,-136(s0)
    8000566c:	94ba                	add	s1,s1,a4
    8000566e:	17c4a703          	lw	a4,380(s1)
    80005672:	9f35                	addw	a4,a4,a3
    80005674:	16e4ae23          	sw	a4,380(s1)
    vma->len -= len;
    80005678:	1707a703          	lw	a4,368(a5)
    8000567c:	40d706bb          	subw	a3,a4,a3
    80005680:	16d7a823          	sw	a3,368(a5)
    80005684:	b59d                	j	800054ea <sys_munmap+0xc2>
    vma->addr = 0;
    80005686:	1607b423          	sd	zero,360(a5)
    vma->len = 0;
    8000568a:	1607a823          	sw	zero,368(a5)
    vma->offset = 0;
    8000568e:	0496                	slli	s1,s1,0x5
    80005690:	f7843703          	ld	a4,-136(s0)
    80005694:	94ba                	add	s1,s1,a4
    80005696:	1604ae23          	sw	zero,380(s1)
    vma->flags = 0;
    8000569a:	1604ac23          	sw	zero,376(s1)
    vma->prot = 0;
    8000569e:	1607aa23          	sw	zero,372(a5)
    fileclose(vma->f);
    800056a2:	1804b503          	ld	a0,384(s1)
    800056a6:	ffffe097          	auipc	ra,0xffffe
    800056aa:	5e2080e7          	jalr	1506(ra) # 80003c88 <fileclose>
    vma->f = 0;
    800056ae:	1804b023          	sd	zero,384(s1)
    800056b2:	bd25                	j	800054ea <sys_munmap+0xc2>
    panic("unexpected munmap");
    800056b4:	00003517          	auipc	a0,0x3
    800056b8:	02c50513          	addi	a0,a0,44 # 800086e0 <syscalls+0x330>
    800056bc:	00001097          	auipc	ra,0x1
    800056c0:	c1c080e7          	jalr	-996(ra) # 800062d8 <panic>
    return -1;
    800056c4:	5d7d                	li	s10,-1
    800056c6:	b515                	j	800054ea <sys_munmap+0xc2>
    800056c8:	5d7d                	li	s10,-1
    800056ca:	b505                	j	800054ea <sys_munmap+0xc2>
    return -1;
    800056cc:	5d7d                	li	s10,-1
    800056ce:	bd31                	j	800054ea <sys_munmap+0xc2>
    800056d0:	5d7d                	li	s10,-1
    800056d2:	bd21                	j	800054ea <sys_munmap+0xc2>
	...

00000000800056e0 <kernelvec>:
    800056e0:	7111                	addi	sp,sp,-256
    800056e2:	e006                	sd	ra,0(sp)
    800056e4:	e40a                	sd	sp,8(sp)
    800056e6:	e80e                	sd	gp,16(sp)
    800056e8:	ec12                	sd	tp,24(sp)
    800056ea:	f016                	sd	t0,32(sp)
    800056ec:	f41a                	sd	t1,40(sp)
    800056ee:	f81e                	sd	t2,48(sp)
    800056f0:	fc22                	sd	s0,56(sp)
    800056f2:	e0a6                	sd	s1,64(sp)
    800056f4:	e4aa                	sd	a0,72(sp)
    800056f6:	e8ae                	sd	a1,80(sp)
    800056f8:	ecb2                	sd	a2,88(sp)
    800056fa:	f0b6                	sd	a3,96(sp)
    800056fc:	f4ba                	sd	a4,104(sp)
    800056fe:	f8be                	sd	a5,112(sp)
    80005700:	fcc2                	sd	a6,120(sp)
    80005702:	e146                	sd	a7,128(sp)
    80005704:	e54a                	sd	s2,136(sp)
    80005706:	e94e                	sd	s3,144(sp)
    80005708:	ed52                	sd	s4,152(sp)
    8000570a:	f156                	sd	s5,160(sp)
    8000570c:	f55a                	sd	s6,168(sp)
    8000570e:	f95e                	sd	s7,176(sp)
    80005710:	fd62                	sd	s8,184(sp)
    80005712:	e1e6                	sd	s9,192(sp)
    80005714:	e5ea                	sd	s10,200(sp)
    80005716:	e9ee                	sd	s11,208(sp)
    80005718:	edf2                	sd	t3,216(sp)
    8000571a:	f1f6                	sd	t4,224(sp)
    8000571c:	f5fa                	sd	t5,232(sp)
    8000571e:	f9fe                	sd	t6,240(sp)
    80005720:	98bfc0ef          	jal	ra,800020aa <kerneltrap>
    80005724:	6082                	ld	ra,0(sp)
    80005726:	6122                	ld	sp,8(sp)
    80005728:	61c2                	ld	gp,16(sp)
    8000572a:	7282                	ld	t0,32(sp)
    8000572c:	7322                	ld	t1,40(sp)
    8000572e:	73c2                	ld	t2,48(sp)
    80005730:	7462                	ld	s0,56(sp)
    80005732:	6486                	ld	s1,64(sp)
    80005734:	6526                	ld	a0,72(sp)
    80005736:	65c6                	ld	a1,80(sp)
    80005738:	6666                	ld	a2,88(sp)
    8000573a:	7686                	ld	a3,96(sp)
    8000573c:	7726                	ld	a4,104(sp)
    8000573e:	77c6                	ld	a5,112(sp)
    80005740:	7866                	ld	a6,120(sp)
    80005742:	688a                	ld	a7,128(sp)
    80005744:	692a                	ld	s2,136(sp)
    80005746:	69ca                	ld	s3,144(sp)
    80005748:	6a6a                	ld	s4,152(sp)
    8000574a:	7a8a                	ld	s5,160(sp)
    8000574c:	7b2a                	ld	s6,168(sp)
    8000574e:	7bca                	ld	s7,176(sp)
    80005750:	7c6a                	ld	s8,184(sp)
    80005752:	6c8e                	ld	s9,192(sp)
    80005754:	6d2e                	ld	s10,200(sp)
    80005756:	6dce                	ld	s11,208(sp)
    80005758:	6e6e                	ld	t3,216(sp)
    8000575a:	7e8e                	ld	t4,224(sp)
    8000575c:	7f2e                	ld	t5,232(sp)
    8000575e:	7fce                	ld	t6,240(sp)
    80005760:	6111                	addi	sp,sp,256
    80005762:	10200073          	sret
    80005766:	00000013          	nop
    8000576a:	00000013          	nop
    8000576e:	0001                	nop

0000000080005770 <timervec>:
    80005770:	34051573          	csrrw	a0,mscratch,a0
    80005774:	e10c                	sd	a1,0(a0)
    80005776:	e510                	sd	a2,8(a0)
    80005778:	e914                	sd	a3,16(a0)
    8000577a:	6d0c                	ld	a1,24(a0)
    8000577c:	7110                	ld	a2,32(a0)
    8000577e:	6194                	ld	a3,0(a1)
    80005780:	96b2                	add	a3,a3,a2
    80005782:	e194                	sd	a3,0(a1)
    80005784:	4589                	li	a1,2
    80005786:	14459073          	csrw	sip,a1
    8000578a:	6914                	ld	a3,16(a0)
    8000578c:	6510                	ld	a2,8(a0)
    8000578e:	610c                	ld	a1,0(a0)
    80005790:	34051573          	csrrw	a0,mscratch,a0
    80005794:	30200073          	mret
	...

000000008000579a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000579a:	1141                	addi	sp,sp,-16
    8000579c:	e422                	sd	s0,8(sp)
    8000579e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800057a0:	0c0007b7          	lui	a5,0xc000
    800057a4:	4705                	li	a4,1
    800057a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800057a8:	c3d8                	sw	a4,4(a5)
}
    800057aa:	6422                	ld	s0,8(sp)
    800057ac:	0141                	addi	sp,sp,16
    800057ae:	8082                	ret

00000000800057b0 <plicinithart>:

void
plicinithart(void)
{
    800057b0:	1141                	addi	sp,sp,-16
    800057b2:	e406                	sd	ra,8(sp)
    800057b4:	e022                	sd	s0,0(sp)
    800057b6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800057b8:	ffffb097          	auipc	ra,0xffffb
    800057bc:	698080e7          	jalr	1688(ra) # 80000e50 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800057c0:	0085171b          	slliw	a4,a0,0x8
    800057c4:	0c0027b7          	lui	a5,0xc002
    800057c8:	97ba                	add	a5,a5,a4
    800057ca:	40200713          	li	a4,1026
    800057ce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800057d2:	00d5151b          	slliw	a0,a0,0xd
    800057d6:	0c2017b7          	lui	a5,0xc201
    800057da:	953e                	add	a0,a0,a5
    800057dc:	00052023          	sw	zero,0(a0)
}
    800057e0:	60a2                	ld	ra,8(sp)
    800057e2:	6402                	ld	s0,0(sp)
    800057e4:	0141                	addi	sp,sp,16
    800057e6:	8082                	ret

00000000800057e8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800057e8:	1141                	addi	sp,sp,-16
    800057ea:	e406                	sd	ra,8(sp)
    800057ec:	e022                	sd	s0,0(sp)
    800057ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800057f0:	ffffb097          	auipc	ra,0xffffb
    800057f4:	660080e7          	jalr	1632(ra) # 80000e50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800057f8:	00d5179b          	slliw	a5,a0,0xd
    800057fc:	0c201537          	lui	a0,0xc201
    80005800:	953e                	add	a0,a0,a5
  return irq;
}
    80005802:	4148                	lw	a0,4(a0)
    80005804:	60a2                	ld	ra,8(sp)
    80005806:	6402                	ld	s0,0(sp)
    80005808:	0141                	addi	sp,sp,16
    8000580a:	8082                	ret

000000008000580c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000580c:	1101                	addi	sp,sp,-32
    8000580e:	ec06                	sd	ra,24(sp)
    80005810:	e822                	sd	s0,16(sp)
    80005812:	e426                	sd	s1,8(sp)
    80005814:	1000                	addi	s0,sp,32
    80005816:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005818:	ffffb097          	auipc	ra,0xffffb
    8000581c:	638080e7          	jalr	1592(ra) # 80000e50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005820:	00d5151b          	slliw	a0,a0,0xd
    80005824:	0c2017b7          	lui	a5,0xc201
    80005828:	97aa                	add	a5,a5,a0
    8000582a:	c3c4                	sw	s1,4(a5)
}
    8000582c:	60e2                	ld	ra,24(sp)
    8000582e:	6442                	ld	s0,16(sp)
    80005830:	64a2                	ld	s1,8(sp)
    80005832:	6105                	addi	sp,sp,32
    80005834:	8082                	ret

0000000080005836 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005836:	1141                	addi	sp,sp,-16
    80005838:	e406                	sd	ra,8(sp)
    8000583a:	e022                	sd	s0,0(sp)
    8000583c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000583e:	479d                	li	a5,7
    80005840:	06a7c963          	blt	a5,a0,800058b2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005844:	0001d797          	auipc	a5,0x1d
    80005848:	7bc78793          	addi	a5,a5,1980 # 80023000 <disk>
    8000584c:	00a78733          	add	a4,a5,a0
    80005850:	6789                	lui	a5,0x2
    80005852:	97ba                	add	a5,a5,a4
    80005854:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005858:	e7ad                	bnez	a5,800058c2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000585a:	00451793          	slli	a5,a0,0x4
    8000585e:	0001f717          	auipc	a4,0x1f
    80005862:	7a270713          	addi	a4,a4,1954 # 80025000 <disk+0x2000>
    80005866:	6314                	ld	a3,0(a4)
    80005868:	96be                	add	a3,a3,a5
    8000586a:	0006b023          	sd	zero,0(a3) # 2000000 <_entry-0x7e000000>
  disk.desc[i].len = 0;
    8000586e:	6314                	ld	a3,0(a4)
    80005870:	96be                	add	a3,a3,a5
    80005872:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005876:	6314                	ld	a3,0(a4)
    80005878:	96be                	add	a3,a3,a5
    8000587a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000587e:	6318                	ld	a4,0(a4)
    80005880:	97ba                	add	a5,a5,a4
    80005882:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005886:	0001d797          	auipc	a5,0x1d
    8000588a:	77a78793          	addi	a5,a5,1914 # 80023000 <disk>
    8000588e:	97aa                	add	a5,a5,a0
    80005890:	6509                	lui	a0,0x2
    80005892:	953e                	add	a0,a0,a5
    80005894:	4785                	li	a5,1
    80005896:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000589a:	0001f517          	auipc	a0,0x1f
    8000589e:	77e50513          	addi	a0,a0,1918 # 80025018 <disk+0x2018>
    800058a2:	ffffc097          	auipc	ra,0xffffc
    800058a6:	e66080e7          	jalr	-410(ra) # 80001708 <wakeup>
}
    800058aa:	60a2                	ld	ra,8(sp)
    800058ac:	6402                	ld	s0,0(sp)
    800058ae:	0141                	addi	sp,sp,16
    800058b0:	8082                	ret
    panic("free_desc 1");
    800058b2:	00003517          	auipc	a0,0x3
    800058b6:	e4650513          	addi	a0,a0,-442 # 800086f8 <syscalls+0x348>
    800058ba:	00001097          	auipc	ra,0x1
    800058be:	a1e080e7          	jalr	-1506(ra) # 800062d8 <panic>
    panic("free_desc 2");
    800058c2:	00003517          	auipc	a0,0x3
    800058c6:	e4650513          	addi	a0,a0,-442 # 80008708 <syscalls+0x358>
    800058ca:	00001097          	auipc	ra,0x1
    800058ce:	a0e080e7          	jalr	-1522(ra) # 800062d8 <panic>

00000000800058d2 <virtio_disk_init>:
{
    800058d2:	1101                	addi	sp,sp,-32
    800058d4:	ec06                	sd	ra,24(sp)
    800058d6:	e822                	sd	s0,16(sp)
    800058d8:	e426                	sd	s1,8(sp)
    800058da:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800058dc:	00003597          	auipc	a1,0x3
    800058e0:	e3c58593          	addi	a1,a1,-452 # 80008718 <syscalls+0x368>
    800058e4:	00020517          	auipc	a0,0x20
    800058e8:	84450513          	addi	a0,a0,-1980 # 80025128 <disk+0x2128>
    800058ec:	00001097          	auipc	ra,0x1
    800058f0:	ea6080e7          	jalr	-346(ra) # 80006792 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058f4:	100017b7          	lui	a5,0x10001
    800058f8:	4398                	lw	a4,0(a5)
    800058fa:	2701                	sext.w	a4,a4
    800058fc:	747277b7          	lui	a5,0x74727
    80005900:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005904:	0ef71163          	bne	a4,a5,800059e6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005908:	100017b7          	lui	a5,0x10001
    8000590c:	43dc                	lw	a5,4(a5)
    8000590e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005910:	4705                	li	a4,1
    80005912:	0ce79a63          	bne	a5,a4,800059e6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005916:	100017b7          	lui	a5,0x10001
    8000591a:	479c                	lw	a5,8(a5)
    8000591c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000591e:	4709                	li	a4,2
    80005920:	0ce79363          	bne	a5,a4,800059e6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005924:	100017b7          	lui	a5,0x10001
    80005928:	47d8                	lw	a4,12(a5)
    8000592a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000592c:	554d47b7          	lui	a5,0x554d4
    80005930:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005934:	0af71963          	bne	a4,a5,800059e6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005938:	100017b7          	lui	a5,0x10001
    8000593c:	4705                	li	a4,1
    8000593e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005940:	470d                	li	a4,3
    80005942:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005944:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005946:	c7ffe737          	lui	a4,0xc7ffe
    8000594a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd051f>
    8000594e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005950:	2701                	sext.w	a4,a4
    80005952:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005954:	472d                	li	a4,11
    80005956:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005958:	473d                	li	a4,15
    8000595a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000595c:	6705                	lui	a4,0x1
    8000595e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005960:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005964:	5bdc                	lw	a5,52(a5)
    80005966:	2781                	sext.w	a5,a5
  if(max == 0)
    80005968:	c7d9                	beqz	a5,800059f6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000596a:	471d                	li	a4,7
    8000596c:	08f77d63          	bgeu	a4,a5,80005a06 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005970:	100014b7          	lui	s1,0x10001
    80005974:	47a1                	li	a5,8
    80005976:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005978:	6609                	lui	a2,0x2
    8000597a:	4581                	li	a1,0
    8000597c:	0001d517          	auipc	a0,0x1d
    80005980:	68450513          	addi	a0,a0,1668 # 80023000 <disk>
    80005984:	ffffa097          	auipc	ra,0xffffa
    80005988:	7f4080e7          	jalr	2036(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000598c:	0001d717          	auipc	a4,0x1d
    80005990:	67470713          	addi	a4,a4,1652 # 80023000 <disk>
    80005994:	00c75793          	srli	a5,a4,0xc
    80005998:	2781                	sext.w	a5,a5
    8000599a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000599c:	0001f797          	auipc	a5,0x1f
    800059a0:	66478793          	addi	a5,a5,1636 # 80025000 <disk+0x2000>
    800059a4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800059a6:	0001d717          	auipc	a4,0x1d
    800059aa:	6da70713          	addi	a4,a4,1754 # 80023080 <disk+0x80>
    800059ae:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800059b0:	0001e717          	auipc	a4,0x1e
    800059b4:	65070713          	addi	a4,a4,1616 # 80024000 <disk+0x1000>
    800059b8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800059ba:	4705                	li	a4,1
    800059bc:	00e78c23          	sb	a4,24(a5)
    800059c0:	00e78ca3          	sb	a4,25(a5)
    800059c4:	00e78d23          	sb	a4,26(a5)
    800059c8:	00e78da3          	sb	a4,27(a5)
    800059cc:	00e78e23          	sb	a4,28(a5)
    800059d0:	00e78ea3          	sb	a4,29(a5)
    800059d4:	00e78f23          	sb	a4,30(a5)
    800059d8:	00e78fa3          	sb	a4,31(a5)
}
    800059dc:	60e2                	ld	ra,24(sp)
    800059de:	6442                	ld	s0,16(sp)
    800059e0:	64a2                	ld	s1,8(sp)
    800059e2:	6105                	addi	sp,sp,32
    800059e4:	8082                	ret
    panic("could not find virtio disk");
    800059e6:	00003517          	auipc	a0,0x3
    800059ea:	d4250513          	addi	a0,a0,-702 # 80008728 <syscalls+0x378>
    800059ee:	00001097          	auipc	ra,0x1
    800059f2:	8ea080e7          	jalr	-1814(ra) # 800062d8 <panic>
    panic("virtio disk has no queue 0");
    800059f6:	00003517          	auipc	a0,0x3
    800059fa:	d5250513          	addi	a0,a0,-686 # 80008748 <syscalls+0x398>
    800059fe:	00001097          	auipc	ra,0x1
    80005a02:	8da080e7          	jalr	-1830(ra) # 800062d8 <panic>
    panic("virtio disk max queue too short");
    80005a06:	00003517          	auipc	a0,0x3
    80005a0a:	d6250513          	addi	a0,a0,-670 # 80008768 <syscalls+0x3b8>
    80005a0e:	00001097          	auipc	ra,0x1
    80005a12:	8ca080e7          	jalr	-1846(ra) # 800062d8 <panic>

0000000080005a16 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005a16:	7159                	addi	sp,sp,-112
    80005a18:	f486                	sd	ra,104(sp)
    80005a1a:	f0a2                	sd	s0,96(sp)
    80005a1c:	eca6                	sd	s1,88(sp)
    80005a1e:	e8ca                	sd	s2,80(sp)
    80005a20:	e4ce                	sd	s3,72(sp)
    80005a22:	e0d2                	sd	s4,64(sp)
    80005a24:	fc56                	sd	s5,56(sp)
    80005a26:	f85a                	sd	s6,48(sp)
    80005a28:	f45e                	sd	s7,40(sp)
    80005a2a:	f062                	sd	s8,32(sp)
    80005a2c:	ec66                	sd	s9,24(sp)
    80005a2e:	e86a                	sd	s10,16(sp)
    80005a30:	1880                	addi	s0,sp,112
    80005a32:	892a                	mv	s2,a0
    80005a34:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005a36:	00c52c83          	lw	s9,12(a0)
    80005a3a:	001c9c9b          	slliw	s9,s9,0x1
    80005a3e:	1c82                	slli	s9,s9,0x20
    80005a40:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005a44:	0001f517          	auipc	a0,0x1f
    80005a48:	6e450513          	addi	a0,a0,1764 # 80025128 <disk+0x2128>
    80005a4c:	00001097          	auipc	ra,0x1
    80005a50:	dd6080e7          	jalr	-554(ra) # 80006822 <acquire>
  for(int i = 0; i < 3; i++){
    80005a54:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005a56:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005a58:	0001db97          	auipc	s7,0x1d
    80005a5c:	5a8b8b93          	addi	s7,s7,1448 # 80023000 <disk>
    80005a60:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005a62:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005a64:	8a4e                	mv	s4,s3
    80005a66:	a051                	j	80005aea <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005a68:	00fb86b3          	add	a3,s7,a5
    80005a6c:	96da                	add	a3,a3,s6
    80005a6e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005a72:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005a74:	0207c563          	bltz	a5,80005a9e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005a78:	2485                	addiw	s1,s1,1
    80005a7a:	0711                	addi	a4,a4,4
    80005a7c:	25548063          	beq	s1,s5,80005cbc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005a80:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005a82:	0001f697          	auipc	a3,0x1f
    80005a86:	59668693          	addi	a3,a3,1430 # 80025018 <disk+0x2018>
    80005a8a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005a8c:	0006c583          	lbu	a1,0(a3)
    80005a90:	fde1                	bnez	a1,80005a68 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005a92:	2785                	addiw	a5,a5,1
    80005a94:	0685                	addi	a3,a3,1
    80005a96:	ff879be3          	bne	a5,s8,80005a8c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005a9a:	57fd                	li	a5,-1
    80005a9c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005a9e:	02905a63          	blez	s1,80005ad2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005aa2:	f9042503          	lw	a0,-112(s0)
    80005aa6:	00000097          	auipc	ra,0x0
    80005aaa:	d90080e7          	jalr	-624(ra) # 80005836 <free_desc>
      for(int j = 0; j < i; j++)
    80005aae:	4785                	li	a5,1
    80005ab0:	0297d163          	bge	a5,s1,80005ad2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005ab4:	f9442503          	lw	a0,-108(s0)
    80005ab8:	00000097          	auipc	ra,0x0
    80005abc:	d7e080e7          	jalr	-642(ra) # 80005836 <free_desc>
      for(int j = 0; j < i; j++)
    80005ac0:	4789                	li	a5,2
    80005ac2:	0097d863          	bge	a5,s1,80005ad2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005ac6:	f9842503          	lw	a0,-104(s0)
    80005aca:	00000097          	auipc	ra,0x0
    80005ace:	d6c080e7          	jalr	-660(ra) # 80005836 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005ad2:	0001f597          	auipc	a1,0x1f
    80005ad6:	65658593          	addi	a1,a1,1622 # 80025128 <disk+0x2128>
    80005ada:	0001f517          	auipc	a0,0x1f
    80005ade:	53e50513          	addi	a0,a0,1342 # 80025018 <disk+0x2018>
    80005ae2:	ffffc097          	auipc	ra,0xffffc
    80005ae6:	a9a080e7          	jalr	-1382(ra) # 8000157c <sleep>
  for(int i = 0; i < 3; i++){
    80005aea:	f9040713          	addi	a4,s0,-112
    80005aee:	84ce                	mv	s1,s3
    80005af0:	bf41                	j	80005a80 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005af2:	20058713          	addi	a4,a1,512
    80005af6:	00471693          	slli	a3,a4,0x4
    80005afa:	0001d717          	auipc	a4,0x1d
    80005afe:	50670713          	addi	a4,a4,1286 # 80023000 <disk>
    80005b02:	9736                	add	a4,a4,a3
    80005b04:	4685                	li	a3,1
    80005b06:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005b0a:	20058713          	addi	a4,a1,512
    80005b0e:	00471693          	slli	a3,a4,0x4
    80005b12:	0001d717          	auipc	a4,0x1d
    80005b16:	4ee70713          	addi	a4,a4,1262 # 80023000 <disk>
    80005b1a:	9736                	add	a4,a4,a3
    80005b1c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005b20:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005b24:	7679                	lui	a2,0xffffe
    80005b26:	963e                	add	a2,a2,a5
    80005b28:	0001f697          	auipc	a3,0x1f
    80005b2c:	4d868693          	addi	a3,a3,1240 # 80025000 <disk+0x2000>
    80005b30:	6298                	ld	a4,0(a3)
    80005b32:	9732                	add	a4,a4,a2
    80005b34:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005b36:	6298                	ld	a4,0(a3)
    80005b38:	9732                	add	a4,a4,a2
    80005b3a:	4541                	li	a0,16
    80005b3c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005b3e:	6298                	ld	a4,0(a3)
    80005b40:	9732                	add	a4,a4,a2
    80005b42:	4505                	li	a0,1
    80005b44:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005b48:	f9442703          	lw	a4,-108(s0)
    80005b4c:	6288                	ld	a0,0(a3)
    80005b4e:	962a                	add	a2,a2,a0
    80005b50:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffcfdce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005b54:	0712                	slli	a4,a4,0x4
    80005b56:	6290                	ld	a2,0(a3)
    80005b58:	963a                	add	a2,a2,a4
    80005b5a:	05890513          	addi	a0,s2,88
    80005b5e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005b60:	6294                	ld	a3,0(a3)
    80005b62:	96ba                	add	a3,a3,a4
    80005b64:	40000613          	li	a2,1024
    80005b68:	c690                	sw	a2,8(a3)
  if(write)
    80005b6a:	140d0063          	beqz	s10,80005caa <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005b6e:	0001f697          	auipc	a3,0x1f
    80005b72:	4926b683          	ld	a3,1170(a3) # 80025000 <disk+0x2000>
    80005b76:	96ba                	add	a3,a3,a4
    80005b78:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005b7c:	0001d817          	auipc	a6,0x1d
    80005b80:	48480813          	addi	a6,a6,1156 # 80023000 <disk>
    80005b84:	0001f517          	auipc	a0,0x1f
    80005b88:	47c50513          	addi	a0,a0,1148 # 80025000 <disk+0x2000>
    80005b8c:	6114                	ld	a3,0(a0)
    80005b8e:	96ba                	add	a3,a3,a4
    80005b90:	00c6d603          	lhu	a2,12(a3)
    80005b94:	00166613          	ori	a2,a2,1
    80005b98:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005b9c:	f9842683          	lw	a3,-104(s0)
    80005ba0:	6110                	ld	a2,0(a0)
    80005ba2:	9732                	add	a4,a4,a2
    80005ba4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005ba8:	20058613          	addi	a2,a1,512
    80005bac:	0612                	slli	a2,a2,0x4
    80005bae:	9642                	add	a2,a2,a6
    80005bb0:	577d                	li	a4,-1
    80005bb2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005bb6:	00469713          	slli	a4,a3,0x4
    80005bba:	6114                	ld	a3,0(a0)
    80005bbc:	96ba                	add	a3,a3,a4
    80005bbe:	03078793          	addi	a5,a5,48
    80005bc2:	97c2                	add	a5,a5,a6
    80005bc4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005bc6:	611c                	ld	a5,0(a0)
    80005bc8:	97ba                	add	a5,a5,a4
    80005bca:	4685                	li	a3,1
    80005bcc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005bce:	611c                	ld	a5,0(a0)
    80005bd0:	97ba                	add	a5,a5,a4
    80005bd2:	4809                	li	a6,2
    80005bd4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005bd8:	611c                	ld	a5,0(a0)
    80005bda:	973e                	add	a4,a4,a5
    80005bdc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005be0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005be4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005be8:	6518                	ld	a4,8(a0)
    80005bea:	00275783          	lhu	a5,2(a4)
    80005bee:	8b9d                	andi	a5,a5,7
    80005bf0:	0786                	slli	a5,a5,0x1
    80005bf2:	97ba                	add	a5,a5,a4
    80005bf4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005bf8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005bfc:	6518                	ld	a4,8(a0)
    80005bfe:	00275783          	lhu	a5,2(a4)
    80005c02:	2785                	addiw	a5,a5,1
    80005c04:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005c08:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005c0c:	100017b7          	lui	a5,0x10001
    80005c10:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005c14:	00492703          	lw	a4,4(s2)
    80005c18:	4785                	li	a5,1
    80005c1a:	02f71163          	bne	a4,a5,80005c3c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    80005c1e:	0001f997          	auipc	s3,0x1f
    80005c22:	50a98993          	addi	s3,s3,1290 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    80005c26:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005c28:	85ce                	mv	a1,s3
    80005c2a:	854a                	mv	a0,s2
    80005c2c:	ffffc097          	auipc	ra,0xffffc
    80005c30:	950080e7          	jalr	-1712(ra) # 8000157c <sleep>
  while(b->disk == 1) {
    80005c34:	00492783          	lw	a5,4(s2)
    80005c38:	fe9788e3          	beq	a5,s1,80005c28 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    80005c3c:	f9042903          	lw	s2,-112(s0)
    80005c40:	20090793          	addi	a5,s2,512
    80005c44:	00479713          	slli	a4,a5,0x4
    80005c48:	0001d797          	auipc	a5,0x1d
    80005c4c:	3b878793          	addi	a5,a5,952 # 80023000 <disk>
    80005c50:	97ba                	add	a5,a5,a4
    80005c52:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005c56:	0001f997          	auipc	s3,0x1f
    80005c5a:	3aa98993          	addi	s3,s3,938 # 80025000 <disk+0x2000>
    80005c5e:	00491713          	slli	a4,s2,0x4
    80005c62:	0009b783          	ld	a5,0(s3)
    80005c66:	97ba                	add	a5,a5,a4
    80005c68:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005c6c:	854a                	mv	a0,s2
    80005c6e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005c72:	00000097          	auipc	ra,0x0
    80005c76:	bc4080e7          	jalr	-1084(ra) # 80005836 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005c7a:	8885                	andi	s1,s1,1
    80005c7c:	f0ed                	bnez	s1,80005c5e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005c7e:	0001f517          	auipc	a0,0x1f
    80005c82:	4aa50513          	addi	a0,a0,1194 # 80025128 <disk+0x2128>
    80005c86:	00001097          	auipc	ra,0x1
    80005c8a:	c50080e7          	jalr	-944(ra) # 800068d6 <release>
}
    80005c8e:	70a6                	ld	ra,104(sp)
    80005c90:	7406                	ld	s0,96(sp)
    80005c92:	64e6                	ld	s1,88(sp)
    80005c94:	6946                	ld	s2,80(sp)
    80005c96:	69a6                	ld	s3,72(sp)
    80005c98:	6a06                	ld	s4,64(sp)
    80005c9a:	7ae2                	ld	s5,56(sp)
    80005c9c:	7b42                	ld	s6,48(sp)
    80005c9e:	7ba2                	ld	s7,40(sp)
    80005ca0:	7c02                	ld	s8,32(sp)
    80005ca2:	6ce2                	ld	s9,24(sp)
    80005ca4:	6d42                	ld	s10,16(sp)
    80005ca6:	6165                	addi	sp,sp,112
    80005ca8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005caa:	0001f697          	auipc	a3,0x1f
    80005cae:	3566b683          	ld	a3,854(a3) # 80025000 <disk+0x2000>
    80005cb2:	96ba                	add	a3,a3,a4
    80005cb4:	4609                	li	a2,2
    80005cb6:	00c69623          	sh	a2,12(a3)
    80005cba:	b5c9                	j	80005b7c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005cbc:	f9042583          	lw	a1,-112(s0)
    80005cc0:	20058793          	addi	a5,a1,512
    80005cc4:	0792                	slli	a5,a5,0x4
    80005cc6:	0001d517          	auipc	a0,0x1d
    80005cca:	3e250513          	addi	a0,a0,994 # 800230a8 <disk+0xa8>
    80005cce:	953e                	add	a0,a0,a5
  if(write)
    80005cd0:	e20d11e3          	bnez	s10,80005af2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005cd4:	20058713          	addi	a4,a1,512
    80005cd8:	00471693          	slli	a3,a4,0x4
    80005cdc:	0001d717          	auipc	a4,0x1d
    80005ce0:	32470713          	addi	a4,a4,804 # 80023000 <disk>
    80005ce4:	9736                	add	a4,a4,a3
    80005ce6:	0a072423          	sw	zero,168(a4)
    80005cea:	b505                	j	80005b0a <virtio_disk_rw+0xf4>

0000000080005cec <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005cec:	1101                	addi	sp,sp,-32
    80005cee:	ec06                	sd	ra,24(sp)
    80005cf0:	e822                	sd	s0,16(sp)
    80005cf2:	e426                	sd	s1,8(sp)
    80005cf4:	e04a                	sd	s2,0(sp)
    80005cf6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005cf8:	0001f517          	auipc	a0,0x1f
    80005cfc:	43050513          	addi	a0,a0,1072 # 80025128 <disk+0x2128>
    80005d00:	00001097          	auipc	ra,0x1
    80005d04:	b22080e7          	jalr	-1246(ra) # 80006822 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005d08:	10001737          	lui	a4,0x10001
    80005d0c:	533c                	lw	a5,96(a4)
    80005d0e:	8b8d                	andi	a5,a5,3
    80005d10:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005d12:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005d16:	0001f797          	auipc	a5,0x1f
    80005d1a:	2ea78793          	addi	a5,a5,746 # 80025000 <disk+0x2000>
    80005d1e:	6b94                	ld	a3,16(a5)
    80005d20:	0207d703          	lhu	a4,32(a5)
    80005d24:	0026d783          	lhu	a5,2(a3)
    80005d28:	06f70163          	beq	a4,a5,80005d8a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005d2c:	0001d917          	auipc	s2,0x1d
    80005d30:	2d490913          	addi	s2,s2,724 # 80023000 <disk>
    80005d34:	0001f497          	auipc	s1,0x1f
    80005d38:	2cc48493          	addi	s1,s1,716 # 80025000 <disk+0x2000>
    __sync_synchronize();
    80005d3c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005d40:	6898                	ld	a4,16(s1)
    80005d42:	0204d783          	lhu	a5,32(s1)
    80005d46:	8b9d                	andi	a5,a5,7
    80005d48:	078e                	slli	a5,a5,0x3
    80005d4a:	97ba                	add	a5,a5,a4
    80005d4c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005d4e:	20078713          	addi	a4,a5,512
    80005d52:	0712                	slli	a4,a4,0x4
    80005d54:	974a                	add	a4,a4,s2
    80005d56:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005d5a:	e731                	bnez	a4,80005da6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005d5c:	20078793          	addi	a5,a5,512
    80005d60:	0792                	slli	a5,a5,0x4
    80005d62:	97ca                	add	a5,a5,s2
    80005d64:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005d66:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005d6a:	ffffc097          	auipc	ra,0xffffc
    80005d6e:	99e080e7          	jalr	-1634(ra) # 80001708 <wakeup>

    disk.used_idx += 1;
    80005d72:	0204d783          	lhu	a5,32(s1)
    80005d76:	2785                	addiw	a5,a5,1
    80005d78:	17c2                	slli	a5,a5,0x30
    80005d7a:	93c1                	srli	a5,a5,0x30
    80005d7c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005d80:	6898                	ld	a4,16(s1)
    80005d82:	00275703          	lhu	a4,2(a4)
    80005d86:	faf71be3          	bne	a4,a5,80005d3c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005d8a:	0001f517          	auipc	a0,0x1f
    80005d8e:	39e50513          	addi	a0,a0,926 # 80025128 <disk+0x2128>
    80005d92:	00001097          	auipc	ra,0x1
    80005d96:	b44080e7          	jalr	-1212(ra) # 800068d6 <release>
}
    80005d9a:	60e2                	ld	ra,24(sp)
    80005d9c:	6442                	ld	s0,16(sp)
    80005d9e:	64a2                	ld	s1,8(sp)
    80005da0:	6902                	ld	s2,0(sp)
    80005da2:	6105                	addi	sp,sp,32
    80005da4:	8082                	ret
      panic("virtio_disk_intr status");
    80005da6:	00003517          	auipc	a0,0x3
    80005daa:	9e250513          	addi	a0,a0,-1566 # 80008788 <syscalls+0x3d8>
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	52a080e7          	jalr	1322(ra) # 800062d8 <panic>

0000000080005db6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005db6:	1141                	addi	sp,sp,-16
    80005db8:	e422                	sd	s0,8(sp)
    80005dba:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005dbc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005dc0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005dc4:	0037979b          	slliw	a5,a5,0x3
    80005dc8:	02004737          	lui	a4,0x2004
    80005dcc:	97ba                	add	a5,a5,a4
    80005dce:	0200c737          	lui	a4,0x200c
    80005dd2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005dd6:	000f4637          	lui	a2,0xf4
    80005dda:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005dde:	95b2                	add	a1,a1,a2
    80005de0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005de2:	00269713          	slli	a4,a3,0x2
    80005de6:	9736                	add	a4,a4,a3
    80005de8:	00371693          	slli	a3,a4,0x3
    80005dec:	00020717          	auipc	a4,0x20
    80005df0:	21470713          	addi	a4,a4,532 # 80026000 <timer_scratch>
    80005df4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005df6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005df8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005dfa:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005dfe:	00000797          	auipc	a5,0x0
    80005e02:	97278793          	addi	a5,a5,-1678 # 80005770 <timervec>
    80005e06:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005e0a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005e0e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005e12:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005e16:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005e1a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005e1e:	30479073          	csrw	mie,a5
}
    80005e22:	6422                	ld	s0,8(sp)
    80005e24:	0141                	addi	sp,sp,16
    80005e26:	8082                	ret

0000000080005e28 <start>:
{
    80005e28:	1141                	addi	sp,sp,-16
    80005e2a:	e406                	sd	ra,8(sp)
    80005e2c:	e022                	sd	s0,0(sp)
    80005e2e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005e30:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005e34:	7779                	lui	a4,0xffffe
    80005e36:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd05bf>
    80005e3a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005e3c:	6705                	lui	a4,0x1
    80005e3e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005e42:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005e44:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005e48:	ffffa797          	auipc	a5,0xffffa
    80005e4c:	4de78793          	addi	a5,a5,1246 # 80000326 <main>
    80005e50:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005e54:	4781                	li	a5,0
    80005e56:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005e5a:	67c1                	lui	a5,0x10
    80005e5c:	17fd                	addi	a5,a5,-1
    80005e5e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005e62:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005e66:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005e6a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005e6e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005e72:	57fd                	li	a5,-1
    80005e74:	83a9                	srli	a5,a5,0xa
    80005e76:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005e7a:	47bd                	li	a5,15
    80005e7c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	f36080e7          	jalr	-202(ra) # 80005db6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005e88:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005e8c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005e8e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005e90:	30200073          	mret
}
    80005e94:	60a2                	ld	ra,8(sp)
    80005e96:	6402                	ld	s0,0(sp)
    80005e98:	0141                	addi	sp,sp,16
    80005e9a:	8082                	ret

0000000080005e9c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005e9c:	715d                	addi	sp,sp,-80
    80005e9e:	e486                	sd	ra,72(sp)
    80005ea0:	e0a2                	sd	s0,64(sp)
    80005ea2:	fc26                	sd	s1,56(sp)
    80005ea4:	f84a                	sd	s2,48(sp)
    80005ea6:	f44e                	sd	s3,40(sp)
    80005ea8:	f052                	sd	s4,32(sp)
    80005eaa:	ec56                	sd	s5,24(sp)
    80005eac:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005eae:	04c05663          	blez	a2,80005efa <consolewrite+0x5e>
    80005eb2:	8a2a                	mv	s4,a0
    80005eb4:	84ae                	mv	s1,a1
    80005eb6:	89b2                	mv	s3,a2
    80005eb8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005eba:	5afd                	li	s5,-1
    80005ebc:	4685                	li	a3,1
    80005ebe:	8626                	mv	a2,s1
    80005ec0:	85d2                	mv	a1,s4
    80005ec2:	fbf40513          	addi	a0,s0,-65
    80005ec6:	ffffc097          	auipc	ra,0xffffc
    80005eca:	c5a080e7          	jalr	-934(ra) # 80001b20 <either_copyin>
    80005ece:	01550c63          	beq	a0,s5,80005ee6 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005ed2:	fbf44503          	lbu	a0,-65(s0)
    80005ed6:	00000097          	auipc	ra,0x0
    80005eda:	78e080e7          	jalr	1934(ra) # 80006664 <uartputc>
  for(i = 0; i < n; i++){
    80005ede:	2905                	addiw	s2,s2,1
    80005ee0:	0485                	addi	s1,s1,1
    80005ee2:	fd299de3          	bne	s3,s2,80005ebc <consolewrite+0x20>
  }

  return i;
}
    80005ee6:	854a                	mv	a0,s2
    80005ee8:	60a6                	ld	ra,72(sp)
    80005eea:	6406                	ld	s0,64(sp)
    80005eec:	74e2                	ld	s1,56(sp)
    80005eee:	7942                	ld	s2,48(sp)
    80005ef0:	79a2                	ld	s3,40(sp)
    80005ef2:	7a02                	ld	s4,32(sp)
    80005ef4:	6ae2                	ld	s5,24(sp)
    80005ef6:	6161                	addi	sp,sp,80
    80005ef8:	8082                	ret
  for(i = 0; i < n; i++){
    80005efa:	4901                	li	s2,0
    80005efc:	b7ed                	j	80005ee6 <consolewrite+0x4a>

0000000080005efe <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005efe:	7119                	addi	sp,sp,-128
    80005f00:	fc86                	sd	ra,120(sp)
    80005f02:	f8a2                	sd	s0,112(sp)
    80005f04:	f4a6                	sd	s1,104(sp)
    80005f06:	f0ca                	sd	s2,96(sp)
    80005f08:	ecce                	sd	s3,88(sp)
    80005f0a:	e8d2                	sd	s4,80(sp)
    80005f0c:	e4d6                	sd	s5,72(sp)
    80005f0e:	e0da                	sd	s6,64(sp)
    80005f10:	fc5e                	sd	s7,56(sp)
    80005f12:	f862                	sd	s8,48(sp)
    80005f14:	f466                	sd	s9,40(sp)
    80005f16:	f06a                	sd	s10,32(sp)
    80005f18:	ec6e                	sd	s11,24(sp)
    80005f1a:	0100                	addi	s0,sp,128
    80005f1c:	8b2a                	mv	s6,a0
    80005f1e:	8aae                	mv	s5,a1
    80005f20:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005f22:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005f26:	00028517          	auipc	a0,0x28
    80005f2a:	21a50513          	addi	a0,a0,538 # 8002e140 <cons>
    80005f2e:	00001097          	auipc	ra,0x1
    80005f32:	8f4080e7          	jalr	-1804(ra) # 80006822 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005f36:	00028497          	auipc	s1,0x28
    80005f3a:	20a48493          	addi	s1,s1,522 # 8002e140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005f3e:	89a6                	mv	s3,s1
    80005f40:	00028917          	auipc	s2,0x28
    80005f44:	29890913          	addi	s2,s2,664 # 8002e1d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005f48:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005f4a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005f4c:	4da9                	li	s11,10
  while(n > 0){
    80005f4e:	07405863          	blez	s4,80005fbe <consoleread+0xc0>
    while(cons.r == cons.w){
    80005f52:	0984a783          	lw	a5,152(s1)
    80005f56:	09c4a703          	lw	a4,156(s1)
    80005f5a:	02f71463          	bne	a4,a5,80005f82 <consoleread+0x84>
      if(myproc()->killed){
    80005f5e:	ffffb097          	auipc	ra,0xffffb
    80005f62:	f1e080e7          	jalr	-226(ra) # 80000e7c <myproc>
    80005f66:	551c                	lw	a5,40(a0)
    80005f68:	e7b5                	bnez	a5,80005fd4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005f6a:	85ce                	mv	a1,s3
    80005f6c:	854a                	mv	a0,s2
    80005f6e:	ffffb097          	auipc	ra,0xffffb
    80005f72:	60e080e7          	jalr	1550(ra) # 8000157c <sleep>
    while(cons.r == cons.w){
    80005f76:	0984a783          	lw	a5,152(s1)
    80005f7a:	09c4a703          	lw	a4,156(s1)
    80005f7e:	fef700e3          	beq	a4,a5,80005f5e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005f82:	0017871b          	addiw	a4,a5,1
    80005f86:	08e4ac23          	sw	a4,152(s1)
    80005f8a:	07f7f713          	andi	a4,a5,127
    80005f8e:	9726                	add	a4,a4,s1
    80005f90:	01874703          	lbu	a4,24(a4)
    80005f94:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005f98:	079c0663          	beq	s8,s9,80006004 <consoleread+0x106>
    cbuf = c;
    80005f9c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005fa0:	4685                	li	a3,1
    80005fa2:	f8f40613          	addi	a2,s0,-113
    80005fa6:	85d6                	mv	a1,s5
    80005fa8:	855a                	mv	a0,s6
    80005faa:	ffffc097          	auipc	ra,0xffffc
    80005fae:	b20080e7          	jalr	-1248(ra) # 80001aca <either_copyout>
    80005fb2:	01a50663          	beq	a0,s10,80005fbe <consoleread+0xc0>
    dst++;
    80005fb6:	0a85                	addi	s5,s5,1
    --n;
    80005fb8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005fba:	f9bc1ae3          	bne	s8,s11,80005f4e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005fbe:	00028517          	auipc	a0,0x28
    80005fc2:	18250513          	addi	a0,a0,386 # 8002e140 <cons>
    80005fc6:	00001097          	auipc	ra,0x1
    80005fca:	910080e7          	jalr	-1776(ra) # 800068d6 <release>

  return target - n;
    80005fce:	414b853b          	subw	a0,s7,s4
    80005fd2:	a811                	j	80005fe6 <consoleread+0xe8>
        release(&cons.lock);
    80005fd4:	00028517          	auipc	a0,0x28
    80005fd8:	16c50513          	addi	a0,a0,364 # 8002e140 <cons>
    80005fdc:	00001097          	auipc	ra,0x1
    80005fe0:	8fa080e7          	jalr	-1798(ra) # 800068d6 <release>
        return -1;
    80005fe4:	557d                	li	a0,-1
}
    80005fe6:	70e6                	ld	ra,120(sp)
    80005fe8:	7446                	ld	s0,112(sp)
    80005fea:	74a6                	ld	s1,104(sp)
    80005fec:	7906                	ld	s2,96(sp)
    80005fee:	69e6                	ld	s3,88(sp)
    80005ff0:	6a46                	ld	s4,80(sp)
    80005ff2:	6aa6                	ld	s5,72(sp)
    80005ff4:	6b06                	ld	s6,64(sp)
    80005ff6:	7be2                	ld	s7,56(sp)
    80005ff8:	7c42                	ld	s8,48(sp)
    80005ffa:	7ca2                	ld	s9,40(sp)
    80005ffc:	7d02                	ld	s10,32(sp)
    80005ffe:	6de2                	ld	s11,24(sp)
    80006000:	6109                	addi	sp,sp,128
    80006002:	8082                	ret
      if(n < target){
    80006004:	000a071b          	sext.w	a4,s4
    80006008:	fb777be3          	bgeu	a4,s7,80005fbe <consoleread+0xc0>
        cons.r--;
    8000600c:	00028717          	auipc	a4,0x28
    80006010:	1cf72623          	sw	a5,460(a4) # 8002e1d8 <cons+0x98>
    80006014:	b76d                	j	80005fbe <consoleread+0xc0>

0000000080006016 <consputc>:
{
    80006016:	1141                	addi	sp,sp,-16
    80006018:	e406                	sd	ra,8(sp)
    8000601a:	e022                	sd	s0,0(sp)
    8000601c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000601e:	10000793          	li	a5,256
    80006022:	00f50a63          	beq	a0,a5,80006036 <consputc+0x20>
    uartputc_sync(c);
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	564080e7          	jalr	1380(ra) # 8000658a <uartputc_sync>
}
    8000602e:	60a2                	ld	ra,8(sp)
    80006030:	6402                	ld	s0,0(sp)
    80006032:	0141                	addi	sp,sp,16
    80006034:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80006036:	4521                	li	a0,8
    80006038:	00000097          	auipc	ra,0x0
    8000603c:	552080e7          	jalr	1362(ra) # 8000658a <uartputc_sync>
    80006040:	02000513          	li	a0,32
    80006044:	00000097          	auipc	ra,0x0
    80006048:	546080e7          	jalr	1350(ra) # 8000658a <uartputc_sync>
    8000604c:	4521                	li	a0,8
    8000604e:	00000097          	auipc	ra,0x0
    80006052:	53c080e7          	jalr	1340(ra) # 8000658a <uartputc_sync>
    80006056:	bfe1                	j	8000602e <consputc+0x18>

0000000080006058 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80006058:	1101                	addi	sp,sp,-32
    8000605a:	ec06                	sd	ra,24(sp)
    8000605c:	e822                	sd	s0,16(sp)
    8000605e:	e426                	sd	s1,8(sp)
    80006060:	e04a                	sd	s2,0(sp)
    80006062:	1000                	addi	s0,sp,32
    80006064:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006066:	00028517          	auipc	a0,0x28
    8000606a:	0da50513          	addi	a0,a0,218 # 8002e140 <cons>
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	7b4080e7          	jalr	1972(ra) # 80006822 <acquire>

  switch(c){
    80006076:	47d5                	li	a5,21
    80006078:	0af48663          	beq	s1,a5,80006124 <consoleintr+0xcc>
    8000607c:	0297ca63          	blt	a5,s1,800060b0 <consoleintr+0x58>
    80006080:	47a1                	li	a5,8
    80006082:	0ef48763          	beq	s1,a5,80006170 <consoleintr+0x118>
    80006086:	47c1                	li	a5,16
    80006088:	10f49a63          	bne	s1,a5,8000619c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    8000608c:	ffffc097          	auipc	ra,0xffffc
    80006090:	aea080e7          	jalr	-1302(ra) # 80001b76 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80006094:	00028517          	auipc	a0,0x28
    80006098:	0ac50513          	addi	a0,a0,172 # 8002e140 <cons>
    8000609c:	00001097          	auipc	ra,0x1
    800060a0:	83a080e7          	jalr	-1990(ra) # 800068d6 <release>
}
    800060a4:	60e2                	ld	ra,24(sp)
    800060a6:	6442                	ld	s0,16(sp)
    800060a8:	64a2                	ld	s1,8(sp)
    800060aa:	6902                	ld	s2,0(sp)
    800060ac:	6105                	addi	sp,sp,32
    800060ae:	8082                	ret
  switch(c){
    800060b0:	07f00793          	li	a5,127
    800060b4:	0af48e63          	beq	s1,a5,80006170 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800060b8:	00028717          	auipc	a4,0x28
    800060bc:	08870713          	addi	a4,a4,136 # 8002e140 <cons>
    800060c0:	0a072783          	lw	a5,160(a4)
    800060c4:	09872703          	lw	a4,152(a4)
    800060c8:	9f99                	subw	a5,a5,a4
    800060ca:	07f00713          	li	a4,127
    800060ce:	fcf763e3          	bltu	a4,a5,80006094 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800060d2:	47b5                	li	a5,13
    800060d4:	0cf48763          	beq	s1,a5,800061a2 <consoleintr+0x14a>
      consputc(c);
    800060d8:	8526                	mv	a0,s1
    800060da:	00000097          	auipc	ra,0x0
    800060de:	f3c080e7          	jalr	-196(ra) # 80006016 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800060e2:	00028797          	auipc	a5,0x28
    800060e6:	05e78793          	addi	a5,a5,94 # 8002e140 <cons>
    800060ea:	0a07a703          	lw	a4,160(a5)
    800060ee:	0017069b          	addiw	a3,a4,1
    800060f2:	0006861b          	sext.w	a2,a3
    800060f6:	0ad7a023          	sw	a3,160(a5)
    800060fa:	07f77713          	andi	a4,a4,127
    800060fe:	97ba                	add	a5,a5,a4
    80006100:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80006104:	47a9                	li	a5,10
    80006106:	0cf48563          	beq	s1,a5,800061d0 <consoleintr+0x178>
    8000610a:	4791                	li	a5,4
    8000610c:	0cf48263          	beq	s1,a5,800061d0 <consoleintr+0x178>
    80006110:	00028797          	auipc	a5,0x28
    80006114:	0c87a783          	lw	a5,200(a5) # 8002e1d8 <cons+0x98>
    80006118:	0807879b          	addiw	a5,a5,128
    8000611c:	f6f61ce3          	bne	a2,a5,80006094 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006120:	863e                	mv	a2,a5
    80006122:	a07d                	j	800061d0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80006124:	00028717          	auipc	a4,0x28
    80006128:	01c70713          	addi	a4,a4,28 # 8002e140 <cons>
    8000612c:	0a072783          	lw	a5,160(a4)
    80006130:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006134:	00028497          	auipc	s1,0x28
    80006138:	00c48493          	addi	s1,s1,12 # 8002e140 <cons>
    while(cons.e != cons.w &&
    8000613c:	4929                	li	s2,10
    8000613e:	f4f70be3          	beq	a4,a5,80006094 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006142:	37fd                	addiw	a5,a5,-1
    80006144:	07f7f713          	andi	a4,a5,127
    80006148:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000614a:	01874703          	lbu	a4,24(a4)
    8000614e:	f52703e3          	beq	a4,s2,80006094 <consoleintr+0x3c>
      cons.e--;
    80006152:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80006156:	10000513          	li	a0,256
    8000615a:	00000097          	auipc	ra,0x0
    8000615e:	ebc080e7          	jalr	-324(ra) # 80006016 <consputc>
    while(cons.e != cons.w &&
    80006162:	0a04a783          	lw	a5,160(s1)
    80006166:	09c4a703          	lw	a4,156(s1)
    8000616a:	fcf71ce3          	bne	a4,a5,80006142 <consoleintr+0xea>
    8000616e:	b71d                	j	80006094 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006170:	00028717          	auipc	a4,0x28
    80006174:	fd070713          	addi	a4,a4,-48 # 8002e140 <cons>
    80006178:	0a072783          	lw	a5,160(a4)
    8000617c:	09c72703          	lw	a4,156(a4)
    80006180:	f0f70ae3          	beq	a4,a5,80006094 <consoleintr+0x3c>
      cons.e--;
    80006184:	37fd                	addiw	a5,a5,-1
    80006186:	00028717          	auipc	a4,0x28
    8000618a:	04f72d23          	sw	a5,90(a4) # 8002e1e0 <cons+0xa0>
      consputc(BACKSPACE);
    8000618e:	10000513          	li	a0,256
    80006192:	00000097          	auipc	ra,0x0
    80006196:	e84080e7          	jalr	-380(ra) # 80006016 <consputc>
    8000619a:	bded                	j	80006094 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000619c:	ee048ce3          	beqz	s1,80006094 <consoleintr+0x3c>
    800061a0:	bf21                	j	800060b8 <consoleintr+0x60>
      consputc(c);
    800061a2:	4529                	li	a0,10
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	e72080e7          	jalr	-398(ra) # 80006016 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800061ac:	00028797          	auipc	a5,0x28
    800061b0:	f9478793          	addi	a5,a5,-108 # 8002e140 <cons>
    800061b4:	0a07a703          	lw	a4,160(a5)
    800061b8:	0017069b          	addiw	a3,a4,1
    800061bc:	0006861b          	sext.w	a2,a3
    800061c0:	0ad7a023          	sw	a3,160(a5)
    800061c4:	07f77713          	andi	a4,a4,127
    800061c8:	97ba                	add	a5,a5,a4
    800061ca:	4729                	li	a4,10
    800061cc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800061d0:	00028797          	auipc	a5,0x28
    800061d4:	00c7a623          	sw	a2,12(a5) # 8002e1dc <cons+0x9c>
        wakeup(&cons.r);
    800061d8:	00028517          	auipc	a0,0x28
    800061dc:	00050513          	mv	a0,a0
    800061e0:	ffffb097          	auipc	ra,0xffffb
    800061e4:	528080e7          	jalr	1320(ra) # 80001708 <wakeup>
    800061e8:	b575                	j	80006094 <consoleintr+0x3c>

00000000800061ea <consoleinit>:

void
consoleinit(void)
{
    800061ea:	1141                	addi	sp,sp,-16
    800061ec:	e406                	sd	ra,8(sp)
    800061ee:	e022                	sd	s0,0(sp)
    800061f0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800061f2:	00002597          	auipc	a1,0x2
    800061f6:	5ae58593          	addi	a1,a1,1454 # 800087a0 <syscalls+0x3f0>
    800061fa:	00028517          	auipc	a0,0x28
    800061fe:	f4650513          	addi	a0,a0,-186 # 8002e140 <cons>
    80006202:	00000097          	auipc	ra,0x0
    80006206:	590080e7          	jalr	1424(ra) # 80006792 <initlock>

  uartinit();
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	330080e7          	jalr	816(ra) # 8000653a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006212:	0001b797          	auipc	a5,0x1b
    80006216:	eb678793          	addi	a5,a5,-330 # 800210c8 <devsw>
    8000621a:	00000717          	auipc	a4,0x0
    8000621e:	ce470713          	addi	a4,a4,-796 # 80005efe <consoleread>
    80006222:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006224:	00000717          	auipc	a4,0x0
    80006228:	c7870713          	addi	a4,a4,-904 # 80005e9c <consolewrite>
    8000622c:	ef98                	sd	a4,24(a5)
}
    8000622e:	60a2                	ld	ra,8(sp)
    80006230:	6402                	ld	s0,0(sp)
    80006232:	0141                	addi	sp,sp,16
    80006234:	8082                	ret

0000000080006236 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006236:	7179                	addi	sp,sp,-48
    80006238:	f406                	sd	ra,40(sp)
    8000623a:	f022                	sd	s0,32(sp)
    8000623c:	ec26                	sd	s1,24(sp)
    8000623e:	e84a                	sd	s2,16(sp)
    80006240:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006242:	c219                	beqz	a2,80006248 <printint+0x12>
    80006244:	08054663          	bltz	a0,800062d0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006248:	2501                	sext.w	a0,a0
    8000624a:	4881                	li	a7,0
    8000624c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006250:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006252:	2581                	sext.w	a1,a1
    80006254:	00002617          	auipc	a2,0x2
    80006258:	57c60613          	addi	a2,a2,1404 # 800087d0 <digits>
    8000625c:	883a                	mv	a6,a4
    8000625e:	2705                	addiw	a4,a4,1
    80006260:	02b577bb          	remuw	a5,a0,a1
    80006264:	1782                	slli	a5,a5,0x20
    80006266:	9381                	srli	a5,a5,0x20
    80006268:	97b2                	add	a5,a5,a2
    8000626a:	0007c783          	lbu	a5,0(a5)
    8000626e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006272:	0005079b          	sext.w	a5,a0
    80006276:	02b5553b          	divuw	a0,a0,a1
    8000627a:	0685                	addi	a3,a3,1
    8000627c:	feb7f0e3          	bgeu	a5,a1,8000625c <printint+0x26>

  if(sign)
    80006280:	00088b63          	beqz	a7,80006296 <printint+0x60>
    buf[i++] = '-';
    80006284:	fe040793          	addi	a5,s0,-32
    80006288:	973e                	add	a4,a4,a5
    8000628a:	02d00793          	li	a5,45
    8000628e:	fef70823          	sb	a5,-16(a4)
    80006292:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006296:	02e05763          	blez	a4,800062c4 <printint+0x8e>
    8000629a:	fd040793          	addi	a5,s0,-48
    8000629e:	00e784b3          	add	s1,a5,a4
    800062a2:	fff78913          	addi	s2,a5,-1
    800062a6:	993a                	add	s2,s2,a4
    800062a8:	377d                	addiw	a4,a4,-1
    800062aa:	1702                	slli	a4,a4,0x20
    800062ac:	9301                	srli	a4,a4,0x20
    800062ae:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800062b2:	fff4c503          	lbu	a0,-1(s1)
    800062b6:	00000097          	auipc	ra,0x0
    800062ba:	d60080e7          	jalr	-672(ra) # 80006016 <consputc>
  while(--i >= 0)
    800062be:	14fd                	addi	s1,s1,-1
    800062c0:	ff2499e3          	bne	s1,s2,800062b2 <printint+0x7c>
}
    800062c4:	70a2                	ld	ra,40(sp)
    800062c6:	7402                	ld	s0,32(sp)
    800062c8:	64e2                	ld	s1,24(sp)
    800062ca:	6942                	ld	s2,16(sp)
    800062cc:	6145                	addi	sp,sp,48
    800062ce:	8082                	ret
    x = -xx;
    800062d0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800062d4:	4885                	li	a7,1
    x = -xx;
    800062d6:	bf9d                	j	8000624c <printint+0x16>

00000000800062d8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800062d8:	1101                	addi	sp,sp,-32
    800062da:	ec06                	sd	ra,24(sp)
    800062dc:	e822                	sd	s0,16(sp)
    800062de:	e426                	sd	s1,8(sp)
    800062e0:	1000                	addi	s0,sp,32
    800062e2:	84aa                	mv	s1,a0
  pr.locking = 0;
    800062e4:	00028797          	auipc	a5,0x28
    800062e8:	f007ae23          	sw	zero,-228(a5) # 8002e200 <pr+0x18>
  printf("panic: ");
    800062ec:	00002517          	auipc	a0,0x2
    800062f0:	4bc50513          	addi	a0,a0,1212 # 800087a8 <syscalls+0x3f8>
    800062f4:	00000097          	auipc	ra,0x0
    800062f8:	02e080e7          	jalr	46(ra) # 80006322 <printf>
  printf(s);
    800062fc:	8526                	mv	a0,s1
    800062fe:	00000097          	auipc	ra,0x0
    80006302:	024080e7          	jalr	36(ra) # 80006322 <printf>
  printf("\n");
    80006306:	00002517          	auipc	a0,0x2
    8000630a:	d4250513          	addi	a0,a0,-702 # 80008048 <etext+0x48>
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	014080e7          	jalr	20(ra) # 80006322 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006316:	4785                	li	a5,1
    80006318:	00003717          	auipc	a4,0x3
    8000631c:	d0f72223          	sw	a5,-764(a4) # 8000901c <panicked>
  for(;;)
    80006320:	a001                	j	80006320 <panic+0x48>

0000000080006322 <printf>:
{
    80006322:	7131                	addi	sp,sp,-192
    80006324:	fc86                	sd	ra,120(sp)
    80006326:	f8a2                	sd	s0,112(sp)
    80006328:	f4a6                	sd	s1,104(sp)
    8000632a:	f0ca                	sd	s2,96(sp)
    8000632c:	ecce                	sd	s3,88(sp)
    8000632e:	e8d2                	sd	s4,80(sp)
    80006330:	e4d6                	sd	s5,72(sp)
    80006332:	e0da                	sd	s6,64(sp)
    80006334:	fc5e                	sd	s7,56(sp)
    80006336:	f862                	sd	s8,48(sp)
    80006338:	f466                	sd	s9,40(sp)
    8000633a:	f06a                	sd	s10,32(sp)
    8000633c:	ec6e                	sd	s11,24(sp)
    8000633e:	0100                	addi	s0,sp,128
    80006340:	8a2a                	mv	s4,a0
    80006342:	e40c                	sd	a1,8(s0)
    80006344:	e810                	sd	a2,16(s0)
    80006346:	ec14                	sd	a3,24(s0)
    80006348:	f018                	sd	a4,32(s0)
    8000634a:	f41c                	sd	a5,40(s0)
    8000634c:	03043823          	sd	a6,48(s0)
    80006350:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006354:	00028d97          	auipc	s11,0x28
    80006358:	eacdad83          	lw	s11,-340(s11) # 8002e200 <pr+0x18>
  if(locking)
    8000635c:	020d9b63          	bnez	s11,80006392 <printf+0x70>
  if (fmt == 0)
    80006360:	040a0263          	beqz	s4,800063a4 <printf+0x82>
  va_start(ap, fmt);
    80006364:	00840793          	addi	a5,s0,8
    80006368:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000636c:	000a4503          	lbu	a0,0(s4)
    80006370:	16050263          	beqz	a0,800064d4 <printf+0x1b2>
    80006374:	4481                	li	s1,0
    if(c != '%'){
    80006376:	02500a93          	li	s5,37
    switch(c){
    8000637a:	07000b13          	li	s6,112
  consputc('x');
    8000637e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006380:	00002b97          	auipc	s7,0x2
    80006384:	450b8b93          	addi	s7,s7,1104 # 800087d0 <digits>
    switch(c){
    80006388:	07300c93          	li	s9,115
    8000638c:	06400c13          	li	s8,100
    80006390:	a82d                	j	800063ca <printf+0xa8>
    acquire(&pr.lock);
    80006392:	00028517          	auipc	a0,0x28
    80006396:	e5650513          	addi	a0,a0,-426 # 8002e1e8 <pr>
    8000639a:	00000097          	auipc	ra,0x0
    8000639e:	488080e7          	jalr	1160(ra) # 80006822 <acquire>
    800063a2:	bf7d                	j	80006360 <printf+0x3e>
    panic("null fmt");
    800063a4:	00002517          	auipc	a0,0x2
    800063a8:	41450513          	addi	a0,a0,1044 # 800087b8 <syscalls+0x408>
    800063ac:	00000097          	auipc	ra,0x0
    800063b0:	f2c080e7          	jalr	-212(ra) # 800062d8 <panic>
      consputc(c);
    800063b4:	00000097          	auipc	ra,0x0
    800063b8:	c62080e7          	jalr	-926(ra) # 80006016 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800063bc:	2485                	addiw	s1,s1,1
    800063be:	009a07b3          	add	a5,s4,s1
    800063c2:	0007c503          	lbu	a0,0(a5)
    800063c6:	10050763          	beqz	a0,800064d4 <printf+0x1b2>
    if(c != '%'){
    800063ca:	ff5515e3          	bne	a0,s5,800063b4 <printf+0x92>
    c = fmt[++i] & 0xff;
    800063ce:	2485                	addiw	s1,s1,1
    800063d0:	009a07b3          	add	a5,s4,s1
    800063d4:	0007c783          	lbu	a5,0(a5)
    800063d8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    800063dc:	cfe5                	beqz	a5,800064d4 <printf+0x1b2>
    switch(c){
    800063de:	05678a63          	beq	a5,s6,80006432 <printf+0x110>
    800063e2:	02fb7663          	bgeu	s6,a5,8000640e <printf+0xec>
    800063e6:	09978963          	beq	a5,s9,80006478 <printf+0x156>
    800063ea:	07800713          	li	a4,120
    800063ee:	0ce79863          	bne	a5,a4,800064be <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    800063f2:	f8843783          	ld	a5,-120(s0)
    800063f6:	00878713          	addi	a4,a5,8
    800063fa:	f8e43423          	sd	a4,-120(s0)
    800063fe:	4605                	li	a2,1
    80006400:	85ea                	mv	a1,s10
    80006402:	4388                	lw	a0,0(a5)
    80006404:	00000097          	auipc	ra,0x0
    80006408:	e32080e7          	jalr	-462(ra) # 80006236 <printint>
      break;
    8000640c:	bf45                	j	800063bc <printf+0x9a>
    switch(c){
    8000640e:	0b578263          	beq	a5,s5,800064b2 <printf+0x190>
    80006412:	0b879663          	bne	a5,s8,800064be <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006416:	f8843783          	ld	a5,-120(s0)
    8000641a:	00878713          	addi	a4,a5,8
    8000641e:	f8e43423          	sd	a4,-120(s0)
    80006422:	4605                	li	a2,1
    80006424:	45a9                	li	a1,10
    80006426:	4388                	lw	a0,0(a5)
    80006428:	00000097          	auipc	ra,0x0
    8000642c:	e0e080e7          	jalr	-498(ra) # 80006236 <printint>
      break;
    80006430:	b771                	j	800063bc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006432:	f8843783          	ld	a5,-120(s0)
    80006436:	00878713          	addi	a4,a5,8
    8000643a:	f8e43423          	sd	a4,-120(s0)
    8000643e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006442:	03000513          	li	a0,48
    80006446:	00000097          	auipc	ra,0x0
    8000644a:	bd0080e7          	jalr	-1072(ra) # 80006016 <consputc>
  consputc('x');
    8000644e:	07800513          	li	a0,120
    80006452:	00000097          	auipc	ra,0x0
    80006456:	bc4080e7          	jalr	-1084(ra) # 80006016 <consputc>
    8000645a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000645c:	03c9d793          	srli	a5,s3,0x3c
    80006460:	97de                	add	a5,a5,s7
    80006462:	0007c503          	lbu	a0,0(a5)
    80006466:	00000097          	auipc	ra,0x0
    8000646a:	bb0080e7          	jalr	-1104(ra) # 80006016 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000646e:	0992                	slli	s3,s3,0x4
    80006470:	397d                	addiw	s2,s2,-1
    80006472:	fe0915e3          	bnez	s2,8000645c <printf+0x13a>
    80006476:	b799                	j	800063bc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006478:	f8843783          	ld	a5,-120(s0)
    8000647c:	00878713          	addi	a4,a5,8
    80006480:	f8e43423          	sd	a4,-120(s0)
    80006484:	0007b903          	ld	s2,0(a5)
    80006488:	00090e63          	beqz	s2,800064a4 <printf+0x182>
      for(; *s; s++)
    8000648c:	00094503          	lbu	a0,0(s2)
    80006490:	d515                	beqz	a0,800063bc <printf+0x9a>
        consputc(*s);
    80006492:	00000097          	auipc	ra,0x0
    80006496:	b84080e7          	jalr	-1148(ra) # 80006016 <consputc>
      for(; *s; s++)
    8000649a:	0905                	addi	s2,s2,1
    8000649c:	00094503          	lbu	a0,0(s2)
    800064a0:	f96d                	bnez	a0,80006492 <printf+0x170>
    800064a2:	bf29                	j	800063bc <printf+0x9a>
        s = "(null)";
    800064a4:	00002917          	auipc	s2,0x2
    800064a8:	30c90913          	addi	s2,s2,780 # 800087b0 <syscalls+0x400>
      for(; *s; s++)
    800064ac:	02800513          	li	a0,40
    800064b0:	b7cd                	j	80006492 <printf+0x170>
      consputc('%');
    800064b2:	8556                	mv	a0,s5
    800064b4:	00000097          	auipc	ra,0x0
    800064b8:	b62080e7          	jalr	-1182(ra) # 80006016 <consputc>
      break;
    800064bc:	b701                	j	800063bc <printf+0x9a>
      consputc('%');
    800064be:	8556                	mv	a0,s5
    800064c0:	00000097          	auipc	ra,0x0
    800064c4:	b56080e7          	jalr	-1194(ra) # 80006016 <consputc>
      consputc(c);
    800064c8:	854a                	mv	a0,s2
    800064ca:	00000097          	auipc	ra,0x0
    800064ce:	b4c080e7          	jalr	-1204(ra) # 80006016 <consputc>
      break;
    800064d2:	b5ed                	j	800063bc <printf+0x9a>
  if(locking)
    800064d4:	020d9163          	bnez	s11,800064f6 <printf+0x1d4>
}
    800064d8:	70e6                	ld	ra,120(sp)
    800064da:	7446                	ld	s0,112(sp)
    800064dc:	74a6                	ld	s1,104(sp)
    800064de:	7906                	ld	s2,96(sp)
    800064e0:	69e6                	ld	s3,88(sp)
    800064e2:	6a46                	ld	s4,80(sp)
    800064e4:	6aa6                	ld	s5,72(sp)
    800064e6:	6b06                	ld	s6,64(sp)
    800064e8:	7be2                	ld	s7,56(sp)
    800064ea:	7c42                	ld	s8,48(sp)
    800064ec:	7ca2                	ld	s9,40(sp)
    800064ee:	7d02                	ld	s10,32(sp)
    800064f0:	6de2                	ld	s11,24(sp)
    800064f2:	6129                	addi	sp,sp,192
    800064f4:	8082                	ret
    release(&pr.lock);
    800064f6:	00028517          	auipc	a0,0x28
    800064fa:	cf250513          	addi	a0,a0,-782 # 8002e1e8 <pr>
    800064fe:	00000097          	auipc	ra,0x0
    80006502:	3d8080e7          	jalr	984(ra) # 800068d6 <release>
}
    80006506:	bfc9                	j	800064d8 <printf+0x1b6>

0000000080006508 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006508:	1101                	addi	sp,sp,-32
    8000650a:	ec06                	sd	ra,24(sp)
    8000650c:	e822                	sd	s0,16(sp)
    8000650e:	e426                	sd	s1,8(sp)
    80006510:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006512:	00028497          	auipc	s1,0x28
    80006516:	cd648493          	addi	s1,s1,-810 # 8002e1e8 <pr>
    8000651a:	00002597          	auipc	a1,0x2
    8000651e:	2ae58593          	addi	a1,a1,686 # 800087c8 <syscalls+0x418>
    80006522:	8526                	mv	a0,s1
    80006524:	00000097          	auipc	ra,0x0
    80006528:	26e080e7          	jalr	622(ra) # 80006792 <initlock>
  pr.locking = 1;
    8000652c:	4785                	li	a5,1
    8000652e:	cc9c                	sw	a5,24(s1)
}
    80006530:	60e2                	ld	ra,24(sp)
    80006532:	6442                	ld	s0,16(sp)
    80006534:	64a2                	ld	s1,8(sp)
    80006536:	6105                	addi	sp,sp,32
    80006538:	8082                	ret

000000008000653a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000653a:	1141                	addi	sp,sp,-16
    8000653c:	e406                	sd	ra,8(sp)
    8000653e:	e022                	sd	s0,0(sp)
    80006540:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006542:	100007b7          	lui	a5,0x10000
    80006546:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000654a:	f8000713          	li	a4,-128
    8000654e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006552:	470d                	li	a4,3
    80006554:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006558:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000655c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006560:	469d                	li	a3,7
    80006562:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006566:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000656a:	00002597          	auipc	a1,0x2
    8000656e:	27e58593          	addi	a1,a1,638 # 800087e8 <digits+0x18>
    80006572:	00028517          	auipc	a0,0x28
    80006576:	c9650513          	addi	a0,a0,-874 # 8002e208 <uart_tx_lock>
    8000657a:	00000097          	auipc	ra,0x0
    8000657e:	218080e7          	jalr	536(ra) # 80006792 <initlock>
}
    80006582:	60a2                	ld	ra,8(sp)
    80006584:	6402                	ld	s0,0(sp)
    80006586:	0141                	addi	sp,sp,16
    80006588:	8082                	ret

000000008000658a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000658a:	1101                	addi	sp,sp,-32
    8000658c:	ec06                	sd	ra,24(sp)
    8000658e:	e822                	sd	s0,16(sp)
    80006590:	e426                	sd	s1,8(sp)
    80006592:	1000                	addi	s0,sp,32
    80006594:	84aa                	mv	s1,a0
  push_off();
    80006596:	00000097          	auipc	ra,0x0
    8000659a:	240080e7          	jalr	576(ra) # 800067d6 <push_off>

  if(panicked){
    8000659e:	00003797          	auipc	a5,0x3
    800065a2:	a7e7a783          	lw	a5,-1410(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800065a6:	10000737          	lui	a4,0x10000
  if(panicked){
    800065aa:	c391                	beqz	a5,800065ae <uartputc_sync+0x24>
    for(;;)
    800065ac:	a001                	j	800065ac <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800065ae:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800065b2:	0ff7f793          	andi	a5,a5,255
    800065b6:	0207f793          	andi	a5,a5,32
    800065ba:	dbf5                	beqz	a5,800065ae <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800065bc:	0ff4f793          	andi	a5,s1,255
    800065c0:	10000737          	lui	a4,0x10000
    800065c4:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800065c8:	00000097          	auipc	ra,0x0
    800065cc:	2ae080e7          	jalr	686(ra) # 80006876 <pop_off>
}
    800065d0:	60e2                	ld	ra,24(sp)
    800065d2:	6442                	ld	s0,16(sp)
    800065d4:	64a2                	ld	s1,8(sp)
    800065d6:	6105                	addi	sp,sp,32
    800065d8:	8082                	ret

00000000800065da <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800065da:	00003717          	auipc	a4,0x3
    800065de:	a4673703          	ld	a4,-1466(a4) # 80009020 <uart_tx_r>
    800065e2:	00003797          	auipc	a5,0x3
    800065e6:	a467b783          	ld	a5,-1466(a5) # 80009028 <uart_tx_w>
    800065ea:	06e78c63          	beq	a5,a4,80006662 <uartstart+0x88>
{
    800065ee:	7139                	addi	sp,sp,-64
    800065f0:	fc06                	sd	ra,56(sp)
    800065f2:	f822                	sd	s0,48(sp)
    800065f4:	f426                	sd	s1,40(sp)
    800065f6:	f04a                	sd	s2,32(sp)
    800065f8:	ec4e                	sd	s3,24(sp)
    800065fa:	e852                	sd	s4,16(sp)
    800065fc:	e456                	sd	s5,8(sp)
    800065fe:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006600:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006604:	00028a17          	auipc	s4,0x28
    80006608:	c04a0a13          	addi	s4,s4,-1020 # 8002e208 <uart_tx_lock>
    uart_tx_r += 1;
    8000660c:	00003497          	auipc	s1,0x3
    80006610:	a1448493          	addi	s1,s1,-1516 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006614:	00003997          	auipc	s3,0x3
    80006618:	a1498993          	addi	s3,s3,-1516 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000661c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006620:	0ff7f793          	andi	a5,a5,255
    80006624:	0207f793          	andi	a5,a5,32
    80006628:	c785                	beqz	a5,80006650 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000662a:	01f77793          	andi	a5,a4,31
    8000662e:	97d2                	add	a5,a5,s4
    80006630:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006634:	0705                	addi	a4,a4,1
    80006636:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006638:	8526                	mv	a0,s1
    8000663a:	ffffb097          	auipc	ra,0xffffb
    8000663e:	0ce080e7          	jalr	206(ra) # 80001708 <wakeup>
    
    WriteReg(THR, c);
    80006642:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006646:	6098                	ld	a4,0(s1)
    80006648:	0009b783          	ld	a5,0(s3)
    8000664c:	fce798e3          	bne	a5,a4,8000661c <uartstart+0x42>
  }
}
    80006650:	70e2                	ld	ra,56(sp)
    80006652:	7442                	ld	s0,48(sp)
    80006654:	74a2                	ld	s1,40(sp)
    80006656:	7902                	ld	s2,32(sp)
    80006658:	69e2                	ld	s3,24(sp)
    8000665a:	6a42                	ld	s4,16(sp)
    8000665c:	6aa2                	ld	s5,8(sp)
    8000665e:	6121                	addi	sp,sp,64
    80006660:	8082                	ret
    80006662:	8082                	ret

0000000080006664 <uartputc>:
{
    80006664:	7179                	addi	sp,sp,-48
    80006666:	f406                	sd	ra,40(sp)
    80006668:	f022                	sd	s0,32(sp)
    8000666a:	ec26                	sd	s1,24(sp)
    8000666c:	e84a                	sd	s2,16(sp)
    8000666e:	e44e                	sd	s3,8(sp)
    80006670:	e052                	sd	s4,0(sp)
    80006672:	1800                	addi	s0,sp,48
    80006674:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006676:	00028517          	auipc	a0,0x28
    8000667a:	b9250513          	addi	a0,a0,-1134 # 8002e208 <uart_tx_lock>
    8000667e:	00000097          	auipc	ra,0x0
    80006682:	1a4080e7          	jalr	420(ra) # 80006822 <acquire>
  if(panicked){
    80006686:	00003797          	auipc	a5,0x3
    8000668a:	9967a783          	lw	a5,-1642(a5) # 8000901c <panicked>
    8000668e:	c391                	beqz	a5,80006692 <uartputc+0x2e>
    for(;;)
    80006690:	a001                	j	80006690 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006692:	00003797          	auipc	a5,0x3
    80006696:	9967b783          	ld	a5,-1642(a5) # 80009028 <uart_tx_w>
    8000669a:	00003717          	auipc	a4,0x3
    8000669e:	98673703          	ld	a4,-1658(a4) # 80009020 <uart_tx_r>
    800066a2:	02070713          	addi	a4,a4,32
    800066a6:	02f71b63          	bne	a4,a5,800066dc <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800066aa:	00028a17          	auipc	s4,0x28
    800066ae:	b5ea0a13          	addi	s4,s4,-1186 # 8002e208 <uart_tx_lock>
    800066b2:	00003497          	auipc	s1,0x3
    800066b6:	96e48493          	addi	s1,s1,-1682 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800066ba:	00003917          	auipc	s2,0x3
    800066be:	96e90913          	addi	s2,s2,-1682 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800066c2:	85d2                	mv	a1,s4
    800066c4:	8526                	mv	a0,s1
    800066c6:	ffffb097          	auipc	ra,0xffffb
    800066ca:	eb6080e7          	jalr	-330(ra) # 8000157c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800066ce:	00093783          	ld	a5,0(s2)
    800066d2:	6098                	ld	a4,0(s1)
    800066d4:	02070713          	addi	a4,a4,32
    800066d8:	fef705e3          	beq	a4,a5,800066c2 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800066dc:	00028497          	auipc	s1,0x28
    800066e0:	b2c48493          	addi	s1,s1,-1236 # 8002e208 <uart_tx_lock>
    800066e4:	01f7f713          	andi	a4,a5,31
    800066e8:	9726                	add	a4,a4,s1
    800066ea:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800066ee:	0785                	addi	a5,a5,1
    800066f0:	00003717          	auipc	a4,0x3
    800066f4:	92f73c23          	sd	a5,-1736(a4) # 80009028 <uart_tx_w>
      uartstart();
    800066f8:	00000097          	auipc	ra,0x0
    800066fc:	ee2080e7          	jalr	-286(ra) # 800065da <uartstart>
      release(&uart_tx_lock);
    80006700:	8526                	mv	a0,s1
    80006702:	00000097          	auipc	ra,0x0
    80006706:	1d4080e7          	jalr	468(ra) # 800068d6 <release>
}
    8000670a:	70a2                	ld	ra,40(sp)
    8000670c:	7402                	ld	s0,32(sp)
    8000670e:	64e2                	ld	s1,24(sp)
    80006710:	6942                	ld	s2,16(sp)
    80006712:	69a2                	ld	s3,8(sp)
    80006714:	6a02                	ld	s4,0(sp)
    80006716:	6145                	addi	sp,sp,48
    80006718:	8082                	ret

000000008000671a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000671a:	1141                	addi	sp,sp,-16
    8000671c:	e422                	sd	s0,8(sp)
    8000671e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006720:	100007b7          	lui	a5,0x10000
    80006724:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006728:	8b85                	andi	a5,a5,1
    8000672a:	cb91                	beqz	a5,8000673e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000672c:	100007b7          	lui	a5,0x10000
    80006730:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006734:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006738:	6422                	ld	s0,8(sp)
    8000673a:	0141                	addi	sp,sp,16
    8000673c:	8082                	ret
    return -1;
    8000673e:	557d                	li	a0,-1
    80006740:	bfe5                	j	80006738 <uartgetc+0x1e>

0000000080006742 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006742:	1101                	addi	sp,sp,-32
    80006744:	ec06                	sd	ra,24(sp)
    80006746:	e822                	sd	s0,16(sp)
    80006748:	e426                	sd	s1,8(sp)
    8000674a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000674c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000674e:	00000097          	auipc	ra,0x0
    80006752:	fcc080e7          	jalr	-52(ra) # 8000671a <uartgetc>
    if(c == -1)
    80006756:	00950763          	beq	a0,s1,80006764 <uartintr+0x22>
      break;
    consoleintr(c);
    8000675a:	00000097          	auipc	ra,0x0
    8000675e:	8fe080e7          	jalr	-1794(ra) # 80006058 <consoleintr>
  while(1){
    80006762:	b7f5                	j	8000674e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006764:	00028497          	auipc	s1,0x28
    80006768:	aa448493          	addi	s1,s1,-1372 # 8002e208 <uart_tx_lock>
    8000676c:	8526                	mv	a0,s1
    8000676e:	00000097          	auipc	ra,0x0
    80006772:	0b4080e7          	jalr	180(ra) # 80006822 <acquire>
  uartstart();
    80006776:	00000097          	auipc	ra,0x0
    8000677a:	e64080e7          	jalr	-412(ra) # 800065da <uartstart>
  release(&uart_tx_lock);
    8000677e:	8526                	mv	a0,s1
    80006780:	00000097          	auipc	ra,0x0
    80006784:	156080e7          	jalr	342(ra) # 800068d6 <release>
}
    80006788:	60e2                	ld	ra,24(sp)
    8000678a:	6442                	ld	s0,16(sp)
    8000678c:	64a2                	ld	s1,8(sp)
    8000678e:	6105                	addi	sp,sp,32
    80006790:	8082                	ret

0000000080006792 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006792:	1141                	addi	sp,sp,-16
    80006794:	e422                	sd	s0,8(sp)
    80006796:	0800                	addi	s0,sp,16
  lk->name = name;
    80006798:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000679a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000679e:	00053823          	sd	zero,16(a0)
}
    800067a2:	6422                	ld	s0,8(sp)
    800067a4:	0141                	addi	sp,sp,16
    800067a6:	8082                	ret

00000000800067a8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800067a8:	411c                	lw	a5,0(a0)
    800067aa:	e399                	bnez	a5,800067b0 <holding+0x8>
    800067ac:	4501                	li	a0,0
  return r;
}
    800067ae:	8082                	ret
{
    800067b0:	1101                	addi	sp,sp,-32
    800067b2:	ec06                	sd	ra,24(sp)
    800067b4:	e822                	sd	s0,16(sp)
    800067b6:	e426                	sd	s1,8(sp)
    800067b8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800067ba:	6904                	ld	s1,16(a0)
    800067bc:	ffffa097          	auipc	ra,0xffffa
    800067c0:	6a4080e7          	jalr	1700(ra) # 80000e60 <mycpu>
    800067c4:	40a48533          	sub	a0,s1,a0
    800067c8:	00153513          	seqz	a0,a0
}
    800067cc:	60e2                	ld	ra,24(sp)
    800067ce:	6442                	ld	s0,16(sp)
    800067d0:	64a2                	ld	s1,8(sp)
    800067d2:	6105                	addi	sp,sp,32
    800067d4:	8082                	ret

00000000800067d6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800067d6:	1101                	addi	sp,sp,-32
    800067d8:	ec06                	sd	ra,24(sp)
    800067da:	e822                	sd	s0,16(sp)
    800067dc:	e426                	sd	s1,8(sp)
    800067de:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800067e0:	100024f3          	csrr	s1,sstatus
    800067e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800067e8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800067ea:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800067ee:	ffffa097          	auipc	ra,0xffffa
    800067f2:	672080e7          	jalr	1650(ra) # 80000e60 <mycpu>
    800067f6:	5d3c                	lw	a5,120(a0)
    800067f8:	cf89                	beqz	a5,80006812 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800067fa:	ffffa097          	auipc	ra,0xffffa
    800067fe:	666080e7          	jalr	1638(ra) # 80000e60 <mycpu>
    80006802:	5d3c                	lw	a5,120(a0)
    80006804:	2785                	addiw	a5,a5,1
    80006806:	dd3c                	sw	a5,120(a0)
}
    80006808:	60e2                	ld	ra,24(sp)
    8000680a:	6442                	ld	s0,16(sp)
    8000680c:	64a2                	ld	s1,8(sp)
    8000680e:	6105                	addi	sp,sp,32
    80006810:	8082                	ret
    mycpu()->intena = old;
    80006812:	ffffa097          	auipc	ra,0xffffa
    80006816:	64e080e7          	jalr	1614(ra) # 80000e60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000681a:	8085                	srli	s1,s1,0x1
    8000681c:	8885                	andi	s1,s1,1
    8000681e:	dd64                	sw	s1,124(a0)
    80006820:	bfe9                	j	800067fa <push_off+0x24>

0000000080006822 <acquire>:
{
    80006822:	1101                	addi	sp,sp,-32
    80006824:	ec06                	sd	ra,24(sp)
    80006826:	e822                	sd	s0,16(sp)
    80006828:	e426                	sd	s1,8(sp)
    8000682a:	1000                	addi	s0,sp,32
    8000682c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000682e:	00000097          	auipc	ra,0x0
    80006832:	fa8080e7          	jalr	-88(ra) # 800067d6 <push_off>
  if(holding(lk))
    80006836:	8526                	mv	a0,s1
    80006838:	00000097          	auipc	ra,0x0
    8000683c:	f70080e7          	jalr	-144(ra) # 800067a8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006840:	4705                	li	a4,1
  if(holding(lk))
    80006842:	e115                	bnez	a0,80006866 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006844:	87ba                	mv	a5,a4
    80006846:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000684a:	2781                	sext.w	a5,a5
    8000684c:	ffe5                	bnez	a5,80006844 <acquire+0x22>
  __sync_synchronize();
    8000684e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006852:	ffffa097          	auipc	ra,0xffffa
    80006856:	60e080e7          	jalr	1550(ra) # 80000e60 <mycpu>
    8000685a:	e888                	sd	a0,16(s1)
}
    8000685c:	60e2                	ld	ra,24(sp)
    8000685e:	6442                	ld	s0,16(sp)
    80006860:	64a2                	ld	s1,8(sp)
    80006862:	6105                	addi	sp,sp,32
    80006864:	8082                	ret
    panic("acquire");
    80006866:	00002517          	auipc	a0,0x2
    8000686a:	f8a50513          	addi	a0,a0,-118 # 800087f0 <digits+0x20>
    8000686e:	00000097          	auipc	ra,0x0
    80006872:	a6a080e7          	jalr	-1430(ra) # 800062d8 <panic>

0000000080006876 <pop_off>:

void
pop_off(void)
{
    80006876:	1141                	addi	sp,sp,-16
    80006878:	e406                	sd	ra,8(sp)
    8000687a:	e022                	sd	s0,0(sp)
    8000687c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000687e:	ffffa097          	auipc	ra,0xffffa
    80006882:	5e2080e7          	jalr	1506(ra) # 80000e60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006886:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000688a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000688c:	e78d                	bnez	a5,800068b6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000688e:	5d3c                	lw	a5,120(a0)
    80006890:	02f05b63          	blez	a5,800068c6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006894:	37fd                	addiw	a5,a5,-1
    80006896:	0007871b          	sext.w	a4,a5
    8000689a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000689c:	eb09                	bnez	a4,800068ae <pop_off+0x38>
    8000689e:	5d7c                	lw	a5,124(a0)
    800068a0:	c799                	beqz	a5,800068ae <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800068a2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800068a6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800068aa:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800068ae:	60a2                	ld	ra,8(sp)
    800068b0:	6402                	ld	s0,0(sp)
    800068b2:	0141                	addi	sp,sp,16
    800068b4:	8082                	ret
    panic("pop_off - interruptible");
    800068b6:	00002517          	auipc	a0,0x2
    800068ba:	f4250513          	addi	a0,a0,-190 # 800087f8 <digits+0x28>
    800068be:	00000097          	auipc	ra,0x0
    800068c2:	a1a080e7          	jalr	-1510(ra) # 800062d8 <panic>
    panic("pop_off");
    800068c6:	00002517          	auipc	a0,0x2
    800068ca:	f4a50513          	addi	a0,a0,-182 # 80008810 <digits+0x40>
    800068ce:	00000097          	auipc	ra,0x0
    800068d2:	a0a080e7          	jalr	-1526(ra) # 800062d8 <panic>

00000000800068d6 <release>:
{
    800068d6:	1101                	addi	sp,sp,-32
    800068d8:	ec06                	sd	ra,24(sp)
    800068da:	e822                	sd	s0,16(sp)
    800068dc:	e426                	sd	s1,8(sp)
    800068de:	1000                	addi	s0,sp,32
    800068e0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800068e2:	00000097          	auipc	ra,0x0
    800068e6:	ec6080e7          	jalr	-314(ra) # 800067a8 <holding>
    800068ea:	c115                	beqz	a0,8000690e <release+0x38>
  lk->cpu = 0;
    800068ec:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800068f0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800068f4:	0f50000f          	fence	iorw,ow
    800068f8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800068fc:	00000097          	auipc	ra,0x0
    80006900:	f7a080e7          	jalr	-134(ra) # 80006876 <pop_off>
}
    80006904:	60e2                	ld	ra,24(sp)
    80006906:	6442                	ld	s0,16(sp)
    80006908:	64a2                	ld	s1,8(sp)
    8000690a:	6105                	addi	sp,sp,32
    8000690c:	8082                	ret
    panic("release");
    8000690e:	00002517          	auipc	a0,0x2
    80006912:	f0a50513          	addi	a0,a0,-246 # 80008818 <digits+0x48>
    80006916:	00000097          	auipc	ra,0x0
    8000691a:	9c2080e7          	jalr	-1598(ra) # 800062d8 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
